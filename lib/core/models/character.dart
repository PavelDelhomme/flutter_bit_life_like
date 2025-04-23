import 'dart:math';
import 'package:bitlife_like/core/models/skill.dart';
import 'package:bitlife_like/core/models/skill_tree.dart';
import 'package:bitlife_like/core/system/game_event.dart';
import 'package:hive/hive.dart';

import 'package:bitlife_like/core/services/data_service.dart';
import 'package:bitlife_like/core/services/skill_tree_manager.dart';
import 'package:bitlife_like/core/shared/bank_account.dart';
import 'package:bitlife_like/core/shared/inventory_item.dart';
import 'package:bitlife_like/core/shared/item_factory.dart';
import 'package:bitlife_like/core/shared/legal.dart';
import 'package:bitlife_like/core/shared/pet.dart';
import 'package:bitlife_like/core/shared/tax_system.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/antique.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/arme.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/jewelry.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/real_estate.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/vehicle.dart';
import 'package:bitlife_like/plugins/core_plugins/book_system/models/book.dart';
import 'package:bitlife_like/plugins/social_plugins/education/models/education.dart';
import 'package:bitlife_like/plugins/tech_plugins/marketplace_system/models/marketplace_item.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/models/business.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/models/career.dart';
import 'activity.dart';
import 'package:bitlife_like/plugins/tech_plugins/crafting/models/recipe.dart';

import 'asset.dart';
import 'license.dart';
import 'relationship.dart';
import 'event.dart';
import 'package:bitlife_like/core/services/inheritance_service.dart'; // AJOUTE CECI !

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

  // double money;
  // Map<String, BankAccount> bankAccounts = {};
  List<BankAccount> bankAccounts = [];
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

  List<MarketplaceItem> marketplaceItems = [];

  List<InventoryItem> inventory = [];

  SkillTree? unlockedSkillTree;
  List<Activity> scheduledActivities = [];
  Map<String, double> skillLevels = {}; // Niveaux de compétences rapide accès

  String currentTitle;
  Career? career;
  EducationLevel educationLevel;
  List<String> diplomas;
  List<Course> enrolledCourses = [];
  List<String> completedCourses = [];

  List<License> licenses = [];

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
    //Map<String, List<BankAccount>>? bankAccounts,
    List<BankAccount>? bankAccounts,
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

  double get money => bankAccounts.fold(0.0, (sum, acc) => sum + acc.balance);

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
    for (var account in bankAccounts) {
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


  Character switchToChild({bool autoDeclare = true, bool simulatedFraud = false, double? customDeclaredAmount}) {
    if (children.isEmpty) {
      throw Exception("Pas d'enfants disponibles pour hériter");
    }

    final Character heir = children.first;

    return InheritanceService.processInheritance(
      deceased: this,
      heir: heir,
      autoDeclare: autoDeclare,
      simulatedFraud: simulatedFraud,
      customDeclaredAmount: customDeclaredAmount,
    );
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
      birthdate: DateTime.parse(json['birthdate']),
      zodiacSign: json['zodiacSign'],
      isAlive: json['isAlive'],
      deathDate: json['deathDate'] != null ? DateTime.parse(json['deathDate']) : null,
      deathCause: json['deathCause'],
      stats: json['stats'],
      // bankAccounts: (json['bankAccounts'] as Map<String, dynamic>).map(
      //         (key, value) => MapEntry(key, BankAccount.fromJson(value as Map<String, dynamic>))
      // ),
      bankAccounts: (json['bankAccounts'] as List<dynamic>)
        .map((e) => BankAccount.fromJson(e as Map<String, dynamic>))
        .toList(),
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
      skills: json['datas'],
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
      // 'bankAccounts': bankAccounts.map((k, v) => MapEntry(k, v.toJson())),
      'bankAccounts': bankAccounts.map((e) => e.toJson()).toList(),
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
      'datas': skills.map((key, value) => MapEntry(key, value.toJson())),
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

  /*
  double _getLearningRate() {
    return 1.0 + (stats['intelligence'] ?? 0.5) * 0.01; // Exemple basé sur la statistique d'intelligence
  }
   */

  void learnFromBook(Book book) {
    book.skillEffects.forEach((skillId, exp) {
      practiceSkill(skillId, exp);
    });
  }

  /*
  SkillCategory _getSkillCategory(String skillId) {
    // Logique de mapping entre skillId et category
    return SkillCategory.technical;
  }
   */


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
      bankAccounts.first.balance -= item.price;
      final converted = ItemFactory.fromMarketplace(item, id);
      addToInventory(converted);
    }
  }


  /*
  void _applyItemEffects(MarketplaceItem item) {
    item.skillEffects.forEach((skillId, exp) {
      improveSkill(skillId, exp);
    });
  }
   */

  bool canPurchase(MarketplaceItem item) {
    return item.canPurchase(this);
  }


  void openBankAccount(String bankName, AccountType type, BankingSystem bankingSystem) {
    final bankData = bankingSystem.banks.firstWhere(
      (b) => b['name'] == bankName,
      orElse: () => throw Exception("Banque non trouvée."),
    );

    final regulations = bankData['types'].contains(type.name)
        ? bankingSystem.regulations[type.name]
        : null;
  
    final minimumAge = regulations != null ? regulations['minAge'] ?? 18 : 18;

    final accountNumber = _generateAccountNumber();
  
    bankAccounts.add(BankAccount(
      id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
      accountNumber: accountNumber,
      bankName: bankName,
      accountType: type,
      minimumAge: minimumAge,
    ));
  }

  String _generateAccountNumber() {
    final rand = Random();
    return '${rand.nextInt(9999).toString().padLeft(4, '0')} '
        '${rand.nextInt(9999).toString().padLeft(4, '0')} '
        '${rand.nextInt(9999).toString().padLeft(4, '0')}';
  }


  void inheritAssets(Character deceased) {
    TaxSystem tax = TaxSystem(country: country);

    for (var account in deceased.bankAccounts) {
      double inheritanceTax = tax.calculateInheritanceTax(account.balance);
      double netAmount = account.balance - inheritanceTax;

      deposit(netAmount);
      deceased.withdraw(account.balance);

      addLifeEvent("Héritage de ${account.balance.toStringAsFixed(2)} (taxe: ${inheritanceTax.toStringAsFixed(2)})");
    }
  }

  void addToInventory(InventoryItem item) {
    inventory.add(item);
    // éventuellement effet
    item.skillEffects.forEach((skillId, exp) {
      improveSkill(skillId, exp);
    });
  }

  void removeFromInventory(String itemId) {
    inventory.removeWhere((item) => item.id == itemId);
  }

  InventoryItem? craftItem(List<InventoryItem> providedItems, Recipe recipe) {
    final providedIds = providedItems.map((e) => e.id).toList();

    // Vérifie que tous les composants requis sont présents en quantité suffisante
    for (final componentId in recipe.requiredComponentIds) {
      if (!providedIds.contains(componentId)) return null;
      if (providedIds.where((id) => id == componentId).length < (recipe.quantities[componentId] ?? 1)) {
        return null;
      }
    }

    // Retirer les composants utilisés
    for (final componentId in recipe.requiredComponentIds) {
      int qty = recipe.quantities[componentId] ?? 1;
      for (int i = 0; i < qty; i++) {
        final index = inventory.indexWhere((item) => item.id == componentId);
        if (index != -1) inventory.removeAt(index);
      }
    }

    // Créer un nouvel item basé sur resultItemType
    final crafted = ItemFactory.createItemFromType(recipe.resultItemType);

    if (crafted != null) {
      addToInventory(crafted);
      addLifeEvent("Tu as crafté ${crafted.name} !");
      return crafted;
    }

    return null;
  }


  void unlockSkills() {
    unlockedSkillTree = SkillTreeManager().currentSkillTree;
  }


  void deposit(double amount) {
    if (bankAccounts.isEmpty) {
      bankAccounts.add(BankAccount(
        id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
        accountNumber: '0000 0000 0000',
        bankName: 'Banque Générale',
        accountType: AccountType.checking,
        minimumAge: 0,
        balance: amount,
      ));
    } else {
      bankAccounts.first.balance += amount;
    }
  }

  bool withdraw(double amount) {
    for (var account in bankAccounts) {
      if (account.balance >= amount) {
        account.balance -= amount;
        return true;
      }
    }
    return false;
  }

  void reactToGlobalEvent(GameEvent event) {
    switch (event.type) {
      case 'economic_crisis':
        if (Random().nextDouble() < 0.5) {
          stats['happiness'] = (stats['happiness']! - 10).clamp(0, 100);
          addLifeEvent("J'ai été affecté·e par une crise économique.");
        }
        break;
    // Ajoute d'autres types d'événements ici selon plugins ou type de monde
    }
  }
}
