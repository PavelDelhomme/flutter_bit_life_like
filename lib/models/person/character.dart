import 'dart:math';
import 'package:bitlife_like/models/marketplace.dart';
import 'package:bitlife_like/models/person/skill.dart';
import 'package:bitlife_like/models/work/business.dart';
import 'package:hive/hive.dart';

import '../../services/data_service.dart';
import '../activity.dart';
import '../asset/antique.dart';
import '../asset/arme.dart';
import '../asset/book.dart';
import '../economy/bank_account.dart';
import '../economy/fiscality.dart';
import '../asset/jewelry.dart';
import '../education/education.dart';
import '../legal.dart';
import '../pet.dart';
import '../asset/vehicle.dart';

import 'relationship.dart';
import '../work/career.dart';
import '../asset/assets.dart';
import '../event.dart';
import '../asset/real_estate.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  String id;
  String fullName;
  String gender;
  String country;
  String city;
  int age;
  DateTime birthdate;
  String zodiacSign;
  bool isAlive;
  DateTime? deathDate;
  String? deathCause;
  double auditProbability;

  Map<String, double> stats;

  double money;
  Map<String, BankAccount> bankAccounts = {};
  double creditScore;
  double taxRate;
  List<Business> businesses = []; // Ajouter cette ligne

  List<Relationship> relationships;
  List<Character> parents;
  List<Character> siblings;
  List<Character> children;
  List<Character> partners;
  List<Pet> pets;

  Map<String, SkillMastery> skills = {};

  List<MarketplaceItem> inventory = [];
  SkillTree? unlockedSkillTree;
  List<Activity> scheduledActivities = [];
  Map<String, double> skillLevels = {}; // Niveaux de compétences rapide accès

  String currentTitle;
  Career? career;
  EducationLevel educationLevel;
  List<String> diplomas;
  List<Course> enrolledCourses = [];
  List<String> completedCourses = [];

  // Possessions
  List<Asset> assets;
  List<Vehicle> vehicles;
  List<RealEstate> properties;
  List<Jewelry> jewelries;
  List<Antique> antiques;
  List<Arme> armes;

  // Judiciaire et fiscal
  double declaredIncome;
  double actualIncome;
  bool hasCriminalRecord;
  List<Crime> criminalHistory;
  int yearsInPrison;

  // Offshore et évasion fiscale
  List<OffshoreAccount> offshoreAccounts;

  // Historique
  List<Event> lifeEvents;

  bool isPNJ;

  LegalSystem? legalSystem;

  Character({
    String? id,
    required this.fullName,
    required this.gender,
    required this.country,
    this.taxRate = 0.30,
    required this.city,
    this.age = 0,
    required this.birthdate,
    required this.zodiacSign,
    this.isAlive = true,
    this.deathDate,
    this.deathCause,
    required this.stats,
    this.money = 0,
    Map<String, List<BankAccount>>? bankAccounts,
    List<Business>? businesses,
    this.creditScore = 700,
    List<Relationship>? relationships,
    List<Character>? parents,
    List<Character>? siblings,
    List<Character>? children,
    List<Character>? partners,
    List<Pet>? pets,
    this.currentTitle = "Nourrisson",
    this.career,
    this.educationLevel = EducationLevel.none,
    Map<String, SkillMastery>? skills,
    List<String>? diplomas,
    List<Asset>? assets,
    List<Vehicle>? vehicles,
    List<RealEstate>? properties,
    List<Jewelry>? jewelries,
    List<Antique>? antiques,
    List<Arme>? armes,
    this.declaredIncome = 0,
    this.actualIncome = 0,
    this.hasCriminalRecord = false,
    List<Crime>? criminalHistory,
    this.yearsInPrison = 0,
    List<OffshoreAccount>? offshoreAccounts,
    List<Event>? lifeEvents,
    this.isPNJ = false,
    this.legalSystem,
    this.auditProbability = 0.0,
  }) :
  id = id ?? 'char_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}',
  relationships = relationships ?? [],
  parents = parents ?? [],
  siblings = siblings ?? [],
  children = children ?? [],
  partners = partners ?? [],
  pets = pets ?? [],
  skills = skills ?? {},
  diplomas = diplomas ?? [],
  assets = assets ?? [],
  vehicles = vehicles ?? [],
  properties = properties ?? [],
  jewelries = jewelries ?? [],
  antiques = antiques ?? [],
  armes = armes ?? [],
  criminalHistory = criminalHistory ?? [],
  offshoreAccounts = offshoreAccounts ?? [],
  businesses = businesses ?? [],
  lifeEvents = lifeEvents ?? [];

  double calculateTotalIncome() {
    double total = 0;
    if (career != null) {
      total += career!.calculateAnnualIncome();
    }

    // Revenu passif (loyers, intérêts)
    for (var property in properties) {
      if (property.isRented) {
        total += property.monthlyRent * 12;
      }
    }

    // intérpets des comptes bancaires
    for (var account in bankAccounts.values) { // Utiliser .values
      total += account.balance * (account.interestRate / 100);
    }
    return total;
  }

  // Ajout d'un événement de vie
  void addLifeEvent(String description) {
    lifeEvents.add(Event(
      age: age,
      description: description,
      timestamp: DateTime.now(),
    ));
  }

  // Changement vers le personnage d'un enfant (héritage)
  Character switchToChild() {
    if (children.isEmpty) {
      throw Exception("Pas d'enfants disponibles pour hériter");
    }

    // Sélectionner un enfant (par défaut le premier)
    Character heir = children.first;

    // Transfert d'héritage - appliquer taxes selon pays
    double inheritanceTax = 0.3; // 30% par défaut
    double inheritedAmount = money * (1 - inheritanceTax);
    heir.money = inheritedAmount;

    addLifeEvent("Je suis décédé(e) et mon héritage est passé à ${heir.fullName}");
    heir.addLifeEvent("J'ai hérité de \$${inheritedAmount.toStringAsFixed(2)} de $fullName");

    // Transfert des propriétés
    for (var properti in properties) {
      properti.transfertOwnership(this, heir);
      heir.properties.add(properti);
    }
    isPNJ = true;
    return heir;
  }

  void ageUp() {
    age++;
    // Déclenchement des évènement basé sur lage
  }

  factory Character.fromJson(Map<dynamic, dynamic> json) {
    // Vérification de la cohérence pays/ville
    final country = json['country'];
    final city = json['city'];
    final validCities = DataService.getCitiesForCountrySync(country);

    return Character(
      id: json['id'],
      fullName: json['fullName'],
      taxRate: json['taxRate'] ?? DataService.getTaxRateForCountry(json['country']),
      gender: json['gender'],
      country: json['country'],
      city: validCities.contains(city) ? city : validCities.isNotEmpty ? validCities.first: 'Inconnu',
      age: json['age'],
      birthdate: json['birthdate'],
      zodiacSign: json['zodiacSign'],
      isAlive: json['isAlive'],
      deathDate: json['deathDate'],
      deathCause: json['deathCause'],
      stats: json['stats'],
      money: json['money'],
      bankAccounts: (json['bankAccounts'] as Map<String, dynamic>).map((key, value) => MapEntry(key, BankAccount.fromJson(value))),
      creditScore: json['creditScore'],
      relationships: json['relationships'],
      parents: json['parents'],
      siblings: json['siblings'],
      children: json['children'],
      partners: json['partners'],
      pets: json['pets'],
      currentTitle: json['currentTitle'],
      career: json['career'],
      educationLevel: json['educationLevel'],
      skills: json['skills'],
      diplomas: json['diplomas'],
      assets: json['assets'],
      vehicles: json['vehicles'],
      properties: json['properties'],
      jewelries: json['jewelries'],
      antiques: json['antiques'],
      armes: json['armes'],
      declaredIncome: json['declaredIncome'],
      actualIncome: json['actuelIncome'],
      hasCriminalRecord: json['hasCriminalRecord'],
      criminalHistory: json['criminalHistory'],
      yearsInPrison: json['yearsInPrison'],
      offshoreAccounts: json['offshoreAccounts'],
      lifeEvents: json['lifeEvents'],
      isPNJ: json['isPNJ'],
      legalSystem: json['legalSystem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'country': country,
      'city': city,
      'age': age,
      'birthdate': birthdate.toIso8601String(),
      'zodiacSign': zodiacSign,
      'isAlive': isAlive,
      'deathDate': deathDate?.toIso8601String(),
      'deathCause': deathCause,
      'stats': stats,
      'money': money,
      'bankAccounts': bankAccounts.map((a) => a.toJson()).toList(),
      'creditScore': creditScore,
      'taxRate': taxRate,
      'relationships': relationships.map((r) => r.toJson()).toList(),
      'parents': parents.map((p) => p.toJson()).toList(),
      'siblings': siblings.map((s) => s.toJson()).toList(),
      'children': children.map((c) => c.toJson()).toList(),
      'partners': partners.map((p) => p.toJson()).toList(),
      'pets': pets.map((p) => p.toJson()).toList(),
      'currentTitle': currentTitle,
      'career': career?.toJson(),
      'educationLevel': educationLevel.toString(),
      'skills': skills.map((key, value) => MapEntry(key, value.toJson())),
      'diplomas': diplomas,
      'assets': assets.map((a) => a.toJson()).toList(),
      'vehicles': vehicles.map((v) => v.toJson()).toList(),
      'properties': properties.map((p) => p.toJson()).toList(),
      'jewelries': jewelries.map((j) => j.toJson()).toList(),
      'antiques': antiques.map((a) => a.toJson()).toList(),
      'armes': armes.map((a) => a.toJson()).toList(),
      'declaredIncome': declaredIncome,
      'actualIncome': actualIncome,
      'hasCriminalRecord': hasCriminalRecord,
      'criminalHistory': criminalHistory.map((c) => c.toJson()).toList(),
      'yearsInPrison': yearsInPrison,
      'offshoreAccounts': offshoreAccounts.map((o) => o.toJson()).toList(),
      'lifeEvents': lifeEvents.map((e) => e.toJson()).toList(),
      'isPNJ': isPNJ,
      'legalSystem': legalSystem?.toJson(),
    };
  }

  @override
  Future<void> save() async {
    if (isPNJ) {
      await Hive.box<Character>('pnjs').put(id, this);
    } else {
      await Hive.box<Character>('main_characters').put('current', this);
    }
  }

  @override
  Future<void> delete() async {
    if (isPNJ) {
      await Hive.box<Character>('pnjs').delete(id);
    } else {
      await Hive.box<Character>('main_characters').delete('current');
    }
  }

  double _getLearningRate() {
    return 1.0 + (stats['intelligence'] ?? 0.5) * 0.01; // Exemple basé sur la statistique d'intelligence
  }

  void learnFromBook(Book book) {
    book.skillEffects.forEach((skillId, exp) {
      practiceSkill(skillId, exp);
    });
  }


  SkillCategory _getSkillCategory(String skillId) {
    // Logique de mapping entre skillId et category
    return SkillCategory.technical;
  }


  void practiceSkill(String skillId, double hours) {
    final category = Skill.getCategoryFromId(skillId);
    skills.update(skillId, (skillMastery) {
      final expGain = hours * 10 * skillMastery.getCategoryMultiplier();
      skillMastery.addExperience(expGain);
      return skillMastery;
    }, ifAbsent: () => SkillMastery(
      skillId: skillId,
      category: category,
      experience: hours * 10,
      lastUsed: DateTime.now(),
    )
    );
    //)..addExperience(hours * 10));
  }

  void improveSkill(String skillId, double experience) {
    final category = Skill.getCategoryFromId(skillId);

    skills.update(skillId, (mastery) {
      return SkillMastery(
          skillId: skillId,
          category: category,
          experience: mastery.experience + experience,
          lastUsed: DateTime.now(),
      );
    }, ifAbsent: () => SkillMastery(
        skillId: skillId,
        experience: experience,
        category: category,
        lastUsed: DateTime.now()
    ));
  }

  void purchaseItem(MarketplaceItem item) {
    if (canPurchase(item)) {
      money -= item.price;
      inventory.add(item);
      item.skillEffects.forEach((skillId, exp) {
        improveSkill(skillId, exp);
      });
    }
  }


  void _applyItemEffects(MarketplaceItem item) {
    item.skillEffects.forEach((skillId, exp) {
      improveSkill(skillId, exp);
    });
  }

  bool canPurchase(MarketplaceItem item) {
    return item.canPurchase(this);
  }


  void openBankAccount(String bankName, AccountType type, TaxSystem tax) {
    final accountNumber = _generateAccountNumber();

    bankAccounts[accountNumber] = BankAccount(
      id: 'acc_${DateTime
          .now()
          .millisecondsSinceEpoch}',
      accountNumber: accountNumber,
      bankName: bankName,
      accountType: type,
      minimumAge: tax.bankingRegulations[type]!.minimumAge,
    );
  }

  String _generateAccountNumber() {
    final rand = Random();
    return '${rand.nextInt(9999).toString().padLeft(4, '0')} '
        '${rand.nextInt(9999).toString().padLeft(4, '0')} '
        '${rand.nextInt(9999).toString().padLeft(4, '0')}';
  }


  void inheritAssets(Character deceased) {
    TaxSystem tax = TaxSystem(country: country);

    deceased.bankAccounts.forEach((type, accounts) {
      accounts.forEach((account) {
        double inheritanceTax = tax.calculateInheritanceTax(account.balance);
        double netAmount = account.balance - inheritanceTax;

        this.money += netAmount;
        deceased.money -= account.balance;

        addLifeEvent("Héritage de ${account.balance.toStringAsFixed(2)} (taxe: ${inheritanceTax.toStringAsFixed(2)})");
      });
    });
  }
}
