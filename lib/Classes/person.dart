import 'dart:math';

import 'package:bit_life_like/Classes/objects/arme.dart';
import 'package:bit_life_like/Classes/objects/collectible_item.dart';
import 'package:bit_life_like/Classes/objects/electronic.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';
import 'package:bit_life_like/Classes/objects/vehicle_collection.dart';
import 'package:bit_life_like/Classes/relationship.dart';
import '../screens/work/classes/business.dart';
import '../screens/work/classes/education.dart';
import '../screens/work/classes/job.dart';
import '../services/bank/FinancialService.dart';
import '../services/bank/bank_account.dart';
import 'activity.dart';
import 'objects/antique.dart';
import 'objects/book.dart';
import 'objects/instrument.dart';

class Person {
  String name;
  String gender;
  String country;
  int age = 0;
  double health = 100;
  double appearance = 100;
  double karma = 100;
  double happiness = 100;
  double intelligence = 100;
  bool isImprisoned = false;
  int prisonTerm = 0;

  double stressLevel = 0.0;

  List<BankAccount> bankAccounts;

  // Relation avec d'autres personnages
  Map<Person, Relationship> relationships = {};
  // People
  List<Person> parents = [];
  List<Person> friends = [];
  List<Person> partners = [];
  List<Person> neighbors = [];

  // Works
  List<Job> jobs = [];
  List<Business> businesses = [];
  List<Job> jobHistory = [];

  // Education
  List<EducationLevel> educationHistory = [];
  EducationLevel? currentEducation;
  double academicPerformance = 0;

  Map<String, double> skills = {
    "Communication": 0.0,
    "Leadership": 0.0,
    "Technical": 0.0,
    "Management": 0.0,
    "Manipulation": 0.0,
    "Innovation": 0.0,
    "Recherche": 0.0,
    "Gestion": 0.0,
    "Entrepreneuriat": 0.0,
    "Analyse": 0.0,
    "Synthèse": 0.0,
    "Philosophie": 0.0,
    "Sciences": 0.0,
    "Mathématiques": 0.0,
    "Langues": 0.0,
    "Histoire": 0.0,
    "Créativité": 0.0,
    "Sociabilité": 0.0,
    "Collectif": 0.0
  };

  // Items
  List<CollectibleItem> collectibles = [];
  List<Arme> armes = [];
  List<Jewelry> jewelries = [];
  List<Antique> antiques = [];
  List<RealEstate> realEstates = [];
  List<Instrument> instruments = [];
  List<Electronic> electronics = [];
  List<Book> books = [];

  List<String> permits = [];
  List<Vehicle> vehicles = [];
  List<VehiculeExotique> vehiculeExotiques = [];

  Person({
    required this.name,
    required this.gender,
    required this.country,
    List<BankAccount>? bankAccounts,
    List<Person>? parents,
    List<Person>? partners,
    this.educationHistory = const [],
    this.currentEducation,
    this.academicPerformance = 0,
    required prisonTerm,
    required isImprisoned,
    required intelligence,
    required happiness,
    required karma,
    required appearance,
    required health,
    required age,
    List<Arme>? armes,
    List<Jewelry>? jewelrys,
    List<Antique>? antiques,
    List<RealEstate>? real_estates,
    List<Electronic>? electronics,
    List<Vehicle>? vehicles,
    List<VehiculeExotique>? vehicules_exotique,
    List<Book>? book,
  })
      : bankAccounts = bankAccounts ?? [],
        partners = partners ?? [],
        parents = parents ?? [];

  void ageOneYear() {
    age += 1;
    updateHealthAndHappiness();
    for (var parent in parents) {
      parent.age += 1;
    }
    for (var sibling in siblings) {
      sibling.age += 1;
    }
    for (var friend in friends) {
      friend.age += 1;
    }
    for (var neighbor in neighbors) {
      neighbor.age += 1;
    }

    for (var job in jobs) {
      for (var colleague in job.colleagues) {
        colleague.age += 1;
      }
    }
    for (var education in educations) {
      for (var classmate in education.classmates) {
        classmate.age += 1;
      }
    }

    if (isImprisoned) {
      prisonTerm--;
      if (prisonTerm <= 0) {
        releaseFromPrison();
      }
    }
  }

  void openAccount(Bank bank, String accountType, double initialDeposit,
      {bool isJoint = false}) {
    double interestRate = bank.getInterestRate(accountType);

    try {
      BankAccount newAccount = bank.openAccount(
          accountType, initialDeposit, interestRate, isJoint: isJoint,
          partners: this.partners);
      bankAccounts.add(newAccount);
      print("Account opened at ${bank
          .name} with type $accountType, initial deposit \$${initialDeposit}");
    } catch (e) {
      print(e.toString());
    }
  }

  void marry(Person partner) {
    if (!partners.contains(partner)) {
      parents.add(partner);
      partner.partners.add(this); // Ajouter réciproquement
      // IL faut permettre de choisir si oui ou non il faut ouvrir un compte commun du coup
    }
  }

  void updateHealthAndHappiness() {
    double totalStress = 0;
    jobs.forEach((job) {
      totalStress += job.stressLevel;
      job.workSemester();
    });
    stressLevel = totalStress;
    health -= stressLevel / 100; // Hypothetical reduction in health
    happiness -= stressLevel / 200; // Hypothetical reduction in happiness
  }

  double calculateStress(Job job) {
    double baseStress = job.hoursPerWeek > 40
        ? (job.hoursPerWeek - 40) * 0.5
        : 0;
    return baseStress + (100 - health) * 0.1;
  }

  void releaseFromPrison() {
    isImprisoned = false;
    prisonTerm = 0;
    print("${name} has been released from prison.");
  }

  void retire(Job job) {
    jobs.remove(job);
  }

  void enroll(EducationLevel education) {
    // On sélectionne le premier compte ou un compte spécifié comme principal
    BankAccount? primaryAccount = bankAccounts.isNotEmpty
        ? bankAccounts.first
        : null;
    if (primaryAccount != null && primaryAccount.balance >= education.cost) {
      primaryAccount.balance -= education.cost;
      currentEducation = education;
      academicPerformance = 0;
      print("Enrolled in ${education
          .name} with fees paid from account ${primaryAccount.accountNumber}");
    } else {
      print("Not enough money to enroll in ${education.name}");
    }
  }

  void completeYear() {
    if (currentEducation != null) {
      academicPerformance += 10;
      if (academicPerformance >= 100) {
        educationHistory.add(currentEducation!);
        currentEducation = null;
      }
    }
  }

  void inheritFrom(Person deceased) {
    inheritItems(deceased.collectibles);
    vehicles.addAll(deceased.vehicles);
    realEstates.addAll(deceased.realEstates);

    BankAccount? primaryAccount = bankAccounts.isNotEmpty
        ? bankAccounts.first
        : null;
    if (primaryAccount != null) {
      double inheritanceAmount = deceased.bankAccounts.fold(
          0.0, (sum, acc) => sum + (acc.balance * 0.6)); // Assuming 40% tax
      primaryAccount.deposit(inheritanceAmount);
      print("${name} inherited \$${inheritanceAmount} and assets from ${deceased
          .name} into account ${primaryAccount.accountNumber}");
    } else {
      print(
          "${name} inherited assets but has no bank account to receive funds.");
    }
  }

  void acquireItem(CollectibleItem item) {
    collectibles.add(item);
    print("${name} acquired ${item.display()}");
  }

  void inheritItems(List<CollectibleItem> inheritedItems) {
    collectibles.addAll(inheritedItems);
    print("${name} inherited ${inheritedItems.length} items");
  }

  void startBusiness(String name, String type, double investment) {
    Business newBusiness = Business(
        name: name, type: type, initialInvestment: investment);
    businesses.add(newBusiness);
    print("Started a new business : ${name}");
  }

  double getTotalAssets() {
    double total = bankAccounts.fold(0.0, (sum, acc) => sum + acc.balance);
    total += businesses.fold(0.0, (sum, bsn) => sum + bsn.getBalance());
    return total;
  }

  void applyForBusinessLoan(Bank bank, double amount, int termYears) {
    double projectedRevenue = businesses.fold(
        0.0, (sum, bsn) => sum + bsn.getBalance());
    BankAccount? primaryAccount = bankAccounts.isNotEmpty
        ? bankAccounts.first
        : null;

    if (primaryAccount != null) {
      FinancialService financialService = FinancialService.instance;
      if (financialService.applyForLoan(
          primaryAccount, amount, termYears, projectedRevenue)) {
        primaryAccount.deposit(amount);
        print(
            "Business loan of \$${amount} approved and deposited into account ${primaryAccount
                .accountNumber}");
      } else {
        print(
            "Business loan application denied due to insufficient projected revenue or credit policies.");
      }
    } else {
      print("No account available for loan deposit.");
    }
  }

  void applyForJob(Job job) {
    jobs.add(job);
    jobHistory.add(job);
    print("Applied for ${job.title} at ${job.companyName}");
  }

  void addSalary(Job job) {
    BankAccount? primaryAccount = bankAccounts.isNotEmpty
        ? bankAccounts.first
        : null;
    if (primaryAccount != null) {
      primaryAccount.deposit(job.salary);
      print(
          "Salary of \$${job.salary} added to ${primaryAccount.accountNumber}");
    } else {
      print("No bank account to deposit salary.");
    }
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      gender: json['gender'] as String,
      country: json['country'] as String,
      age: json['age'] ?? 0,
      // Assume that age might not be provided
      health: json['health']?.toDouble() ?? 100.0,
      appearance: json['appearance']?.toDouble() ?? 100.0,
      karma: json['karma']?.toDouble() ?? 100.0,
      happiness: json['happiness']?.toDouble() ?? 100.0,
      intelligence: json['intelligence']?.toDouble() ?? 100.0,
      isImprisoned: json['isImprisoned'] ?? false,
      prisonTerm: json['prisonTerm'] ?? 0,
      bankAccounts: (json['bankAccounts'] as List<dynamic>?)
          ?.map((e) => BankAccount.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'country': country,
      'age': age,
      'health': health,
      'appearance': appearance,
      'karma': karma,
      'happiness': happiness,
      'intelligence': intelligence,
      'isImprisoned': isImprisoned,
      'prisonTerm': prisonTerm,
      'bankAccounts': bankAccounts.map((e) => e.toJson()).toList(),
    };
  }

  void workJob(Job job, int hoursWorked) {
    int regularHours = min(hoursWorked, job.hoursPerWeek);
    int overtimeHours = max(0, hoursWorked - job.hoursPerWeek);
    double overtimePay = job.calculateOvertimePay(overtimeHours);
    double regularPay = regularHours * job.salary;
    double totalPay = regularPay + overtimePay;
    print("Total pay for the week: \$${totalPay}");
  }

  void workExtraHours(Job job, int extraHours) {
    job.hoursPerWeek += extraHours;
    job.stressLevel += ((extraHours / job.hoursPerWeek) * 100);
    stressLevel += (extraHours / job.hoursPerWeek) * 5;
    health -= stressLevel / 100;
    happiness -= stressLevel / 200;
  }

  void improveSkill(String skill, double increment) {
    if (skills.containsKey(skill)) {
      skills[skill] = (skills[skill] ?? 0.0) + increment;
    }
  }

  void useBook(Book book) {
    book.skills.forEach((skill, improvement) {
      improveSkill(skill, improvement);
    });
    print("Read book ${book.title} and improved skills.");
  }

  void advanceEducation() {
    if (currentEducation != null) {
      currentEducation!.competences.forEach((skill, improvement) {
        improveSkill(skill, improvement);
      });
      print("Advanced in ${currentEducation!.name} and improved skills");
    }
  }

  void addVehicle(Vehicle vehicle) {
    this.vehicles.add(vehicle);
    print("Added vehicle to collection: ${vehicle.name}");
  }

  void addJewelry(Jewelry jewelry) {
    this.jewelries.add(jewelry);
    print("Added jewelry to collection: ${jewelry.name}");
  }

  void addArme(Arme arme) {
    this.armes.add(arme);
    print("Added arme to collection : ${arme.name}");
  }

  void addAntique(Antique antique) {
    this.antiques.add(antique);
    print("Added arme to collection : ${antique.name}");
  }

  void addIntrument(Instrument intrument) {
    this.instruments.add(intrument);
    print("Added intrument to collection : ${intrument.name}");
  }

  void addRealEstate(RealEstate realEstate) {
    this.realEstates.add(realEstate);
    print("Added real estate to collection: ${realEstate.name}");
  }

  void addElectronic(Electronic electronic) {
    electronics.add(electronic);
    print("Electronic added: ${electronic.model}");
  }

  void addPermit(String permit) {
    if (!permits.contains(permit)) {
      permits.add(permit);
      print("Permit $permit added to ${name}' collection.");
    }
  }

  void interactWith(Person other, InteractionType type) {
    relationships.putIfAbsent(other, () => Relationship(other));
    Relationship relationship = relationships[other]!;
    relationship.updateRelationship(type, this, other);
  }

  void performActivity(Person? other, Activity activity) {
    if (activity.cost > 0) {
      BankAccount? primaryAccount = bankAccounts.isNotEmpty ? bankAccounts.first : null;
      if (primaryAccount == null || primaryAccount.balance < activity.cost) {
        print("Not enough money to perform ${activity.name}");
        return;
      }
      primaryAccount.withdraw(activity.cost);
    }

    if (activity.skillRequired.isNotEmpty) {
      if (!skills.containsKey(activity.skillRequired) || skills[activity.skillRequired]! < activity.skillImpact) {
        print("${name} does not have enough skill in ${activity.skillRequired} to perform ${activity.name}");
        return;
      }
      skills[activity.skillRequired] = (skills[activity.skillRequired]! + activity.skillImpact).clamp(0.0, 100.0);
      print("${name} improved ${activity.skillRequired} skill by ${activity.skillImpact}");
    }

    if (other != null) {
      relationships.putIfAbsent(other, () => Relationship(other));
      Relationship relationship = relationships[other]!;

      switch (activity.type) {
        case ActivityType.SpendTime:
          print("${name} is spending time with ${other.name}");
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.GiftGiving:
          print("${name} gave a gift to ${other.name}");
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.Conflict:
          print("${name} had conflict with ${other.name}");
          relationship.quality -= activity.relationImpact;
          break;
        case ActivityType.MurderAttempt:
          attemptMurder(other);
          break;
        case ActivityType.Celebration:
          print("${name} is celebrating with ${other.name}");
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.Travel:
          print('${name} is traveling with ${other.name}.');
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.SocialMediaInteraction:
          print('${name} interacted with ${other.name} on social media.');
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.DrinkAtBar:
          print('${name} is drinking at a bar with ${other.name}.');
          relationship.quality += activity.relationImpact;
          happiness += activity.selfImpact;
          break;
        case ActivityType.GoToGym:
          print('${name} is going to the gym with ${other.name}.');
          health += activity.selfImpact;
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.WaterSkiing:
          if (!vehicles.any((vehicle) => vehicle.type == "boat")) {
            print('${name} does not own a boat for water skiing.');
            return;
          }
          print('${name} is water skiing with ${other.name}.');
          happiness += activity.selfImpact;
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.DrugDeal:
          print('${name} is dealing drugs with ${other.name}.');
          karma -= activity.selfImpact;
          break;
        case ActivityType.TakeDrugs:
          print('${name} is taking drugs.');
          health -= activity.selfImpact;
          happiness += activity.relationImpact;
          break;
        case ActivityType.WatchMovie:
          print('${name} is watching a movie with ${other.name}.');
          happiness += activity.selfImpact;
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.PlaySports:
          print('${name} is playing sports with ${other.name}.');
          health += activity.selfImpact;
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.AttendConcert:
          print('${name} is attending a concert with ${other.name}.');
          happiness += activity.selfImpact;
          relationship.quality += activity.relationImpact;
          break;
        case ActivityType.VolunteerWork:
          print('${name} is doing volunteer work with ${other.name}.');
          karma += activity.selfImpact;
          relationship.quality += activity.relationImpact;
          break;
        default:
          print('${name} performed an unknown group activity.');
      }

      relationship.quality = relationship.quality.clamp(0.0, 100.0);
    } else {
      switch (activity.type) {
        case ActivityType.DrinkAtBar:
          print('${name} is drinking at a bar alone.');
          happiness += activity.selfImpact;
          break;
        case ActivityType.GoToGym:
          print('${name} is going to the gym alone.');
          health += activity.selfImpact;
          break;
        case ActivityType.WaterSkiing:
          if (!vehicles.any((vehicle) => vehicle.type == "boat")) {
            print('${name} does not own a boat for water skiing.');
            return;
          }
          print('${name} is water skiing alone.');
          happiness += activity.selfImpact;
          break;
        case ActivityType.DrugDeal:
          print('${name} is dealing drugs alone.');
          karma -= activity.selfImpact;
          break;
        case ActivityType.TakeDrugs:
          print('${name} is taking drugs alone.');
          health -= activity.selfImpact;
          happiness += activity.relationImpact;
          break;
        case ActivityType.WatchMovie:
          print('${name} is watching a movie alone.');
          happiness += activity.selfImpact;
          break;
        case ActivityType.PlaySports:
          print('${name} is playing sports alone.');
          health += activity.selfImpact;
          break;
        case ActivityType.AttendConcert:
          print('${name} is attending a concert alone.');
          happiness += activity.selfImpact;
          break;
        case ActivityType.VolunteerWork:
          print('${name} is doing volunteer work alone.');
          karma += activity.selfImpact;
          break;
        default:
          print('${name} performed an unknown solo activity.');
      }
    }

    // S'assurer que l'health et l'happiness sont dans les resonable limite
    health = health.clamp(0.0, 100.0);
    happiness = happiness.clamp(0.0, 100.0);
    karma = karma.clamp(0.0, 100.0);
  }

  void attemptMurder(Person target) {
    if (armes.isEmpty) {
      print("No weapons available for ${name} to use.");
      return;
    }

    Arme weapon = armes[Random().nextInt(armes.length)];

    print("${name} is attempting to murder ${target.name} with a ${weapon.name}.");

    // Calculer si le meurtre réussit
    double successChance = weapon.lethality;
    bool success = Random().nextDouble() < successChance;

    if (success) {
      print("${name} has successfully murdered ${target.name}!");
      // Supprimer la person cible de toutes les relations
      // Personnage devient mot
      // Autre conséquances légales (baisser le karma, avoir une chance de se faire attraper par la police du coup)
      relationships.remove(target);
    } else {
      print("${name} failed to murder ${target.name}.");
      // Entrenera des représaille, une chance quelle appelle la police, et sinon une baisse que la qualité de la relation
      Relationship relationship = relationships[target]!;
      relationship.quality -= 20;
    }
  }
}