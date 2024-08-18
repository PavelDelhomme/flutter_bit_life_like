import 'dart:developer' as dev;
import 'dart:ffi';
import 'dart:math';

import 'package:bit_life_like/Classes/ficalite/evasion_fiscale.dart';
import 'package:bit_life_like/Classes/ficalite/tax_system.dart';
import 'package:bit_life_like/Classes/objects/arme.dart';
import 'package:bit_life_like/Classes/objects/collectible_item.dart';
import 'package:bit_life_like/Classes/objects/electronic.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';
import 'package:bit_life_like/Classes/objects/vehicle_collection.dart';
import 'package:bit_life_like/Classes/relationship.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../screens/work/classes/business.dart';
import '../screens/work/classes/education.dart';
import '../screens/work/classes/job.dart';
import '../services/bank/FinancialService.dart';
import '../services/bank/bank_account.dart';
import '../services/person.dart';
import 'activity.dart';
import 'life_history_event.dart';
import 'objects/antique.dart';
import 'objects/book.dart';
import 'objects/instrument.dart';

PersonService personService = PersonService();

class Person {
  String name;
  String id;
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
  bool isPNJ = false;

  List<BankAccount> bankAccounts;
  List<OffshoreAccount> offshoreAccounts;
  List<LifeHistoryEvent> lifeHistory = [];

  // Relation avec d'autres personnages
  Map<String, Relationship> relationships = {};
  List<Person> parents = [];
  List<Person> friends = [];
  List<Person> partners = [];
  List<Person> children = [];
  List<Person> siblings = [];
  List<Person> neighbors = [];

  // Works
  List<Job> jobs = [];
  List<Business> businesses = [];
  List<Job> jobHistory = [];

  // Education
  List<EducationLevel> educations = []; // Ajout de la liste d'éducations
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
  List<String> permits = [];
  List<Vehicle> vehicles = [];
  List<VehiculeExotique> vehiculeExotiques = [];
  List<Jewelry> jewelries = [];
  List<Electronic> electronics = [];
  List<Antique> antiques = [];
  List<Instrument> instruments = [];
  List<Arme> armes = [];
  List<RealEstate> realEstates = [];

  Person({
    required this.name,
    String? id,
    required this.gender,
    required this.country,
    List<BankAccount>? bankAccounts,
    List<OffshoreAccount>? offshoreAccounts,
    List<Person>? parents,
    List<Person>? partners,
    List<Person>? children,
    List<Person>? friends,
    List<Person>? siblings,
    List<Person>? neighbors,
    Map<String, Relationship>? relationships, // Ajout des relations
    Map<String, double>? skills,
    List<CollectibleItem>? collectibles,
    List<String>? permits,
    List<Vehicle>? vehicles,
    List<VehiculeExotique>? vehiculeExotiques,
    List<RealEstate>? realEstates,
    this.educations = const [], // Initialisation des éducations
    this.currentEducation,
    this.academicPerformance = 0,
    required this.prisonTerm,
    required this.isImprisoned,
    required this.intelligence,
    required this.happiness,
    required this.karma,
    required this.appearance,
    required this.health,
    required this.age,
  })  : id = id ?? const Uuid().v4(),
        offshoreAccounts = offshoreAccounts ?? [],
        bankAccounts = bankAccounts ?? [BankAccount(accountNumber: 'ACC0000', bankName: 'Default Bank', balance: 0.0)],
        partners = partners ?? [],
        parents = parents ?? [],
        children = children ?? [],
        friends = friends ?? [], // Initialisation des amis
        siblings = siblings ?? [], // Initialisation des frères et soeurs
        neighbors = neighbors ?? [], // Initialisation des voisins
        relationships = relationships ?? {}, // Initialisation des relations
        skills = skills ?? {},
        collectibles = collectibles ?? [],
        permits = permits ?? [],
        vehicles = vehicles ?? [],
        vehiculeExotiques = vehiculeExotiques ?? [],
        realEstates = realEstates ?? [];

  factory Person.fromJson(Map<String, dynamic> json) {
    List<CollectibleItem> parseCollectibles(List<dynamic>? jsonList) {
      if (jsonList == null) return [];
      return jsonList.map<CollectibleItem>((itemJson) {
        switch (itemJson['type']) {
          case 'Arme':
            return Arme.fromJson(itemJson);
          case 'Instrument':
            return Instrument.fromJson(itemJson);
          case 'RealEstate':
            return RealEstate.fromJson(itemJson);
          case 'Jewelry':
            return Jewelry.fromJson(itemJson);
          case 'Antique':
            return Antique.fromJson(itemJson);
          case 'Electronic':
            return Electronic.fromJson(itemJson);
          default:
            throw Exception('Unknown collectible type');
        }
      }).toList();
    }

    List<Vehicle> parseVehicles(List<dynamic>? jsonList) {
      if (jsonList == null) return [];
      return jsonList.map((vehicleJson) {
        switch (vehicleJson['type']) {
          case 'Motorcycle':
            return Moto.fromJson(vehicleJson);
          case 'Car':
            return Voiture.fromJson(vehicleJson);
          case 'Boat':
            return Bateau.fromJson(vehicleJson);
          case 'Airplane':
            return Avion.fromJson(vehicleJson);
          default:
            throw Exception('Unknown vehicle type');
        }
      }).toList();
    }
    List<VehiculeExotique> parseVehiculeExotiques(List<dynamic>? jsonList) {
      if (jsonList == null) return [];
      return jsonList.map<VehiculeExotique>((e) {
        switch (e['type']) {
          case 'Exotic':
            return VehiculeExotique.fromJson(e as Map<String, dynamic>);
          case 'Collection Voiture':
            return VoitureDeCollection.fromJson(e as Map<String, dynamic>);
          case 'Collection Moto':
            return MotoDeCollection.fromJson(e as Map<String, dynamic>);
          case 'Collection Bateau':
            return BateauDeCollection.fromJson(e as Map<String, dynamic>);
          case 'Collection Avion':
            return AvionDeCollection.fromJson(e as Map<String, dynamic>);
          default:
            throw Exception('Unknown exotic vehicle type');
        }
      }).toList();
    }

    return Person(
      id: json['id'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      country: json['country'] as String,
      age: json['age'] ?? 0,
      health: json['health']?.toDouble() ?? 100.0,
      appearance: json['appearance']?.toDouble() ?? 100.0,
      karma: json['karma']?.toDouble() ?? 100.0,
      happiness: json['happiness']?.toDouble() ?? 100.0,
      intelligence: json['intelligence']?.toDouble() ?? 100.0,
      isImprisoned: json['isImprisoned'] ?? false,
      prisonTerm: json['prisonTerm'] ?? 0,
      bankAccounts: (json['bankAccounts'] as List<dynamic>?)
          ?.map((e) => BankAccount.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      parents: (json['parents'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      friends: (json['friends'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      partners: (json['partners'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      siblings: (json['siblings'] as List<dynamic>?)
          ?.map((siblingJson) => Person.fromJson(siblingJson))
          .toList() ?? [],
      neighbors: (json['neighbors'] as List<dynamic>?)
          ?.map((neighborJson) => Person.fromJson(neighborJson))
          .toList() ?? [],
      relationships: (json['relationships'] as Map<String, dynamic>?)
          ?.map((key, value) {
        // Récupération de la personne à partir de l'ID dans les relations
        Person? relatedPerson = personService.getPersonById(key); // Vous devez avoir une méthode pour obtenir une personne par ID
        return MapEntry(key, Relationship.fromJson(value, relatedPerson));
      }) ?? {},

      skills: Map<String, double>.from(json['skills'] ?? {}),
      collectibles: parseCollectibles(json['collectibles'] as List<dynamic>?),
      permits: List<String>.from(json['permits'] ?? []),
      vehicles: parseVehicles(json['vehicles'] as List<dynamic>?),
      vehiculeExotiques: json['vehiculeExotiques'] is List
        ? parseVehiculeExotiques(json['vehiculeExotiques'] as List<dynamic>)
        : [], // Si ce n'est pas une liste retournez une liste vide.
      educations: (json['educations'] as List<dynamic>?)
          ?.map((e) => EducationLevel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      currentEducation: json['currentEducation'] != null
          ? EducationLevel.fromJson(json['currentEducation'])
          : null,
      academicPerformance: json['academicPerformance']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'skills': skills,
      'collectibles': collectibles.map((e) => e.toJson()).toList(),
      'permits': permits,
      'vehicles': vehicles.map((e) => e.toJson()).toList(),
      'vehiculeExotiques': vehiculeExotiques.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'currentEducation': currentEducation?.toJson(),
      'academicPerformance': academicPerformance,
      'parents': parents.map((p) => p.toJson()).toList(),
      'children': children.map((c) => c.toJson()).toList(),
      'friends': friends.map((f) => f.toJson()).toList(),
      'partners': partners.map((p) => p.toJson()).toList(),
      'siblings': siblings.map((sibling) => sibling.toJson()).toList(),
      'neighbors': neighbors.map((neighbor) => neighbor.toJson()).toList(),
      'relationships': relationships.map((key, value) => MapEntry(key, value.toJson())),
    };
  }



  void ageParentYear() {
    for (var parent in parents) {
      parent.age += 1;
    }
    dev.log("Parents have aged. Parent ages: ${parents.map((p) => p.age).toList()}");
  }



  void ageOneYear() {
    age += 1;
    updateHealthAndHappiness();
    ageParentYear();
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

    checkForDeath();
  }

  void openAccount(Bank bank, String accountType, double initialDeposit,
      {bool isJoint = false}) {
    double interestRate = bank.getInterestRate(accountType);

    try {
      BankAccount newAccount = bank.openAccount(
          accountType, initialDeposit, interestRate,
          isJoint: isJoint, partners: this.partners);
      bankAccounts.add(newAccount);
      print(
          "Account opened at ${bank.name} with type $accountType, initial deposit \$${initialDeposit}");
    } catch (e) {
      print(e.toString());
    }
  }

  void openOffshoreAccount(Bank offshoreBank, double initialDeposit, String taxHavenCountry) {
    // Vérifiez si le revenu annuel ou le patrimoine net dépasse un certain seuil
    double annualIncome = calculateAnnualIncome();
    double netWorth = calculateNetWorth(excludeOffshore: false);

    const double minimumIncomeRequired = 100000; // Par exemple, 100 000$ de revenu annuel minimum
    const double minimumNetWorthRequired = 500000; // Par exemple, 500 000$ de patrimoine total minimum

    if (annualIncome >= minimumIncomeRequired || netWorth >= minimumNetWorthRequired) {
      try {
        OffshoreAccount newOffshoreAccount = OffshoreAccount(
          accountNumber: 'OFF${DateTime.now().millisecondsSinceEpoch}',
          bankName: offshoreBank.name,
          balance: initialDeposit,
          taxHavenCountry: taxHavenCountry,
        );
        offshoreAccounts.add(newOffshoreAccount);
        print("Offshore account opened at ${offshoreBank.name} with initial deposit of \$${initialDeposit}");
      } catch (e) {
        print("Failed to open offshore account: $e");
      }
    } else {
      print("Cannot open offshore account: Minimum income or net worth requirements not met.");
    }
  }



  void marry(Person partner) {
    if (!partners.contains(partner)) {
      partners.add(partner);
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
    BankAccount? primaryAccount = bankAccounts.isNotEmpty ? bankAccounts.first : null;

    if (age <= 16) {
      if (parents.isNotEmpty && parents.first.bankAccounts.isNotEmpty) {
        BankAccount parentAccount = parents.first.bankAccounts.first;
        if (parentAccount.balance >= education.cost) {
          parentAccount.balance -= education.cost;
          currentEducation = education;
          academicPerformance = 0;

          currentEducation?.classmates.add(this);
          currentEducation?.classmates.addAll(_generateRandomClassmates(5));

          addLifeHistoryEvent(LifeHistoryEvent(
            description: "Enrolled in ${education.name} with fees paid by parents.",
            timestamp: DateTime.now(),
          ));

          print("Enrolled in ${education.name} with fees paid by parents");
        } else {
          print("Not enough money in parents' account to enroll in ${education.name}");
        }
      } else {
        print("Parents do not have an account to pay for education.");
      }
    } else {
      if (primaryAccount != null && primaryAccount.balance >= education.cost) {
        primaryAccount.balance -= education.cost;
        currentEducation = education;
        academicPerformance = 0;

        currentEducation?.classmates.add(this);
        currentEducation?.classmates.addAll(_generateRandomClassmates(5));

        addLifeHistoryEvent(LifeHistoryEvent(
          description: "Enrolled in ${education.name} with fees paid from own account.",
          timestamp: DateTime.now(),
        ));

        print("Enrolled in ${education.name} with fees paid from own account");
      } else {
        print("Not enough money to enroll in ${education.name}");
      }
    }
  }


  List<Person> _generateRandomClassmates(int count) {
    if (personService.availableCharacters.isEmpty) {
      throw Exception("PersonService is not initialized with characters.");
    }
    return List.generate(count, (_) => personService.getRandomCharacter());
  }
  void completeYear() {
    if (currentEducation != null) {
      academicPerformance += 10; // Par exemple, on ajoute 10% par année
      if (academicPerformance >= 100) {
        educations.add(currentEducation!); // Transfère l'éducation dans l'historique
        addLifeHistoryEvent(LifeHistoryEvent(
          description: "Completed ${currentEducation!.name}.",
          timestamp: DateTime.now(),
        ));
        currentEducation = null; // Réinitialise l'éducation actuelle
      }
    }
  }
  void inheritFrom(Person deceased) {
    // Hériter des objets et des comptes bancaires
    this.bankAccounts.addAll(deceased.bankAccounts); // Hériter des comptes bancaires
    this.offshoreAccounts.addAll(deceased.offshoreAccounts); // Hériter des comptes offshore

    // Hériter des objets
    this.collectibles.addAll(deceased.collectibles); // Hériter des objets
    this.vehicles.addAll(deceased.vehicles); // Hériter des véhicules
    this.realEstates.addAll(deceased.realEstates); // Hériter des biens immobiliers
    this.vehiculeExotiques.addAll(deceased.vehiculeExotiques); // Hériter des véhicules exotiques
    this.jewelries.addAll(deceased.jewelries); // Hériter des bijoux
    this.electronics.addAll(deceased.electronics); // Hériter des électroniques
    this.antiques.addAll(deceased.antiques); // Hériter des antiquités

    print("${this.name} hérite de ${deceased.name} avec ${deceased.bankAccounts.length} comptes bancaires.");
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
    Business newBusiness =
    Business(name: name, type: type, initialInvestment: investment);
    businesses.add(newBusiness);
    print("Started a new business : ${name}");
  }

  double getTotalAssets() {
    double total = bankAccounts.fold(0.0, (sum, acc) => sum + acc.balance);
    total += businesses.fold(0.0, (sum, bsn) => sum + bsn.getBalance());
    return total;
  }

  void applyForBusinessLoan(Bank bank, double amount, int termYears) {
    double projectedRevenue =
    businesses.fold(0.0, (sum, bsn) => sum + bsn.getBalance());
    BankAccount? primaryAccount =
    bankAccounts.isNotEmpty ? bankAccounts.first : null;

    if (primaryAccount != null) {
      FinancialService financialService = FinancialService.instance;
      if (financialService.applyForLoan(
          primaryAccount, amount, termYears, projectedRevenue)) {
        primaryAccount.deposit(amount);
        print(
            "Business loan of \$${amount} approved and deposited into account ${primaryAccount.accountNumber}");
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
    BankAccount? primaryAccount =
    bankAccounts.isNotEmpty ? bankAccounts.first : null;
    if (primaryAccount != null) {
      primaryAccount.deposit(job.salary);
      print("Salary of \$${job.salary} added to ${primaryAccount.accountNumber}");
    } else {
      print("No bank account to deposit salary.");
    }
  }

  void workJob(Job job, int hoursWorked) {
    int regularHours = min(hoursWorked, job.hoursPerWeek);
    int overtimeHours = max(0, hoursWorked - job.hoursPerWeek);
    double overtimePay = job.calculateOvertimePay(overtimeHours);
    double regularPay = regularHours * job.salary;
    double totalPay = regularPay + overtimePay;
    job.salary += overtimePay; // Temporarily increase the salary with overtime pay
    print("Total pay for the week: \$${totalPay}");
  }

  void workExtraHours(Job job, int extraHours) {
    job.hoursPerWeek += extraHours;
    job.stressLevel += ((extraHours / job.hoursPerWeek) * 100);
    stressLevel += (extraHours / job.hoursPerWeek) * 5;
    health -= stressLevel / 100;
    happiness -= stressLevel / 200;
  }

  void updateSkill(String skill, double increment) {
    if (skills.containsKey(skill)) {
      skills[skill] = (skills[skill] ?? 0.0) + increment;
    } else {
      skills[skill] = increment;
    }
  }
  
  void useBook(Book book) {
    book.skills.forEach((skill, improvement) {
      updateSkill(skill, improvement);
    });
    print("Read book ${book.title} and improved skills : ${skills}.");
  }

  void advanceEducation() {
    if (currentEducation != null) {
      currentEducation!.competences.forEach((skill, improvement) {
        updateSkill(skill, improvement);
      });
      print("Advanced in ${currentEducation!.name} and improved skills");
    }
  }

  void addVehicle(Vehicle vehicle) {
    this.vehicles.add(vehicle);
    print("Added vehicle to collection: ${vehicle.name}");
  }

  void addElectronic(Electronic electronic) {
    this.electronics.add(electronic);
    print("${name} acquired ${electronic.display()}");
  }

  void addJewelry(Jewelry jewelry) {
    this.jewelries.add(jewelry);
    print("${name} acquired ${jewelry.display()}");
  }

  void addRealEstate(RealEstate realEstate) {
    this.realEstates.add(realEstate);
    print("${name} acquired ${realEstate.name}");
  }

  void addAntique(Antique antique) {
    this.antiques.add(antique);
    print("$name acquired ${antique.name}");
  }

  void addPermit(String permit) {
    if (!permits.contains(permit)) {
      permits.add(permit);
      print("Permit $permit added to ${name}' collection.");
    }
  }

  void interactWith(Person other, InteractionType type) {
    relationships.putIfAbsent(other.id, () => Relationship(other, quality: 50.0));
    Relationship relationship = relationships[other.id]!;
    relationship.updateRelationship(type, this, other);
  }

  void performActivity(BuildContext context, Person? other, Activity activity) {
    BankAccount? accountToUse;

    // Gérer le coût de l'activité
    if (activity.cost > 0) {
      if (bankAccounts.length > 1) {
        accountToUse = bankAccounts.firstWhere(
              (account) => account.balance >= activity.cost,
          orElse: () => bankAccounts.first,
        );
      } else if (bankAccounts.isNotEmpty) {
        accountToUse = bankAccounts.first;
      }

      if (accountToUse == null || accountToUse.balance < activity.cost) {
        print("Not enough money to perform ${activity.name}");
        _showSnackBar(context, "Not enough money to perform ${activity.name}");
        return;
      }

      accountToUse.withdraw(activity.cost);
    }

    // Gérer les compétences requises
    if (activity.skillRequired.isNotEmpty) {
      if (!skills.containsKey(activity.skillRequired) ||
          skills[activity.skillRequired]! < activity.skillImpact) {
        print("${name} does not have enough skill in ${activity.skillRequired} to perform ${activity.name}");
        _showSnackBar(context, "${name} does not have enough skill in ${activity.skillRequired} to perform ${activity.name}");
        return;
      }

      // Amélioration de la compétence
      skills[activity.skillRequired] =
          (skills[activity.skillRequired]! + activity.skillImpact).clamp(0.0, 100.0);
      print("${name} improved ${activity.skillRequired} skill by ${activity.skillImpact}");
    }

    // Gérer les interactions avec d'autres personnages
    if (other != null) {
      relationships.putIfAbsent(other.id, () => Relationship(other, quality: 50.0));
      Relationship relationship = relationships[other.id]!;

      // Appliquer les effets de l'activité sur la relation et l'état personnel
      switch (activity.type) {
        case ActivityType.SpendTime:
        case ActivityType.GiftGiving:
        case ActivityType.Celebration:
        case ActivityType.Travel:
        case ActivityType.PlaySports:
        case ActivityType.WatchMovie:
        case ActivityType.AttendConcert:
        case ActivityType.DrinkAtBar:
        case ActivityType.GoToGym:
        case ActivityType.CreativeProject:
          relationship.quality += activity.relationImpact;
          happiness += activity.selfImpact;
          break;

        case ActivityType.Conflict:
          relationship.quality -= activity.relationImpact;
          break;

        case ActivityType.BusinessDeal:
        case ActivityType.ManipulationScheme:
          relationship.quality -= activity.relationImpact;
          karma -= activity.selfImpact;
          break;

        case ActivityType.VolunteerWork:
          relationship.quality += activity.relationImpact;
          karma += activity.selfImpact;
          break;

        case ActivityType.DrugDeal:
        case ActivityType.TakeDrugs:
          karma -= activity.selfImpact;
          health -= activity.selfImpact;
          happiness += activity.relationImpact;
          break;

        case ActivityType.MurderAttempt:
          attemptMurder(other);
          return;

        case ActivityType.LanguagePractice:
        case ActivityType.PhilosophicalDebate:
          relationship.quality += activity.relationImpact;
          happiness += activity.selfImpact;
          break;

        default:
          break;
      }

      relationship.quality = relationship.quality.clamp(0.0, 100.0);
      print("Updated relationship quality with ${other.name}: ${relationship.quality}");

      // Afficher un message indiquant l'activité et la personne
      _showSnackBar(context, "You performed ${activity.name} with ${other.name}");
    } else {
      // Gérer les activités en solo
      switch (activity.type) {
        case ActivityType.DrinkAtBar:
        case ActivityType.GoToGym:
        case ActivityType.WatchMovie:
        case ActivityType.PlaySports:
        case ActivityType.AttendConcert:
        case ActivityType.VolunteerWork:
        case ActivityType.CreativeProject:
        case ActivityType.PhilosophicalDebate:
          happiness += activity.selfImpact;
          break;

        case ActivityType.DrugDeal:
        case ActivityType.TakeDrugs:
          karma -= activity.selfImpact;
          health -= activity.selfImpact;
          happiness += activity.relationImpact;
          break;

        case ActivityType.ManipulationScheme:
          karma -= activity.selfImpact;
          break;

        default:
          print("${name} performed an unknown solo activity.");
      }

      // Afficher un message pour les activités solo
      _showSnackBar(context, "You performed ${activity.name}");
    }

    // S'assurer que l'état est maintenu dans des limites raisonnables
    health = health.clamp(0.0, 100.0);
    happiness = happiness.clamp(0.0, 100.0);
    karma = karma.clamp(0.0, 100.0);

    print("Activity ${activity.name} performed. Health: ${health}, Happiness: ${happiness}, Karma: ${karma}");
  }

// Fonction pour afficher le Snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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
      // Supprimer la person cible de toutes les relations par ID
      relationships.remove(target.id);
    } else {
      print("${name} failed to murder ${target.name}.");
      // Entrenera des représailles, potentiellement une baisse de la qualité de la relation
      Relationship relationship = relationships[target.id]!;
      relationship.quality -= 20;
    }
  }


  void manageFinances() {
    // Dépôt de salaire
    for (var job in jobs) {
      double salary = job.salary * job.hoursPerWeek * 4; // salaire mensuel
      if (bankAccounts.isNotEmpty) {
        bankAccounts.first.deposit(salary);
        print("${name} received salary of \$${salary.toStringAsFixed(2)}");
      }
    }

    // Dépense mensuelles (simplifiées)
    if (bankAccounts.isNotEmpty) {
      double monthlyExpenses = bankAccounts.first.monthlyExpenses;
      if (bankAccounts.first.balance >= monthlyExpenses) {
        bankAccounts.first.withdraw(monthlyExpenses);
        print(
            "${name} paid monthly expenses of \$${monthlyExpenses.toStringAsFixed(2)}");
      } else {
        print("${name} cannot afford monthly expenses.");
      }
    }
  }

  double calculateAnnualIncome() {
    double annualIncome = jobs.fold(0.0, (sum, job) => sum + job.salary * 12);

    // Ajouter d'autres sources de revenu, comme les bénéfice des entreprises
    annualIncome += businesses.fold(0.0, (sum, business) => sum + business.income * 12);

    return annualIncome;
  }

  double calculateMonthlyIncome() {
    return jobs.fold(0.0, (sum, job) => sum + FinancialService.adjustCost(job.salary * job.hoursPerWeek * 4));
  }

  double calculateTaxes() {
    // Récupéer le revenu annual
    double annualIncome = calculateAnnualIncome();

    // Appliquer les tranches d'impositions définies dans le système fiscal
    TaxSystem taxSystem = TaxSystem();
    double taxes = taxSystem.calculatePersonalTax(annualIncome);
    return taxes;
  }

  double calculateNetWorth({required bool excludeOffshore}) {
    double totalAssets = bankAccounts.fold(0.0, (sum, acc) => sum + acc.balance);

    if (!excludeOffshore) {
      totalAssets += offshoreAccounts.fold(0.0, (sum, acc) => sum + acc.balance);
    }

    totalAssets += realEstates.fold(0.0, (sum, estate) => sum + estate.value);
    totalAssets += vehicles.fold(0.0, (sum, vehicle) => sum + vehicle.value);
    totalAssets += vehiculeExotiques.fold(0.0, (sum, vehicleExotique) => sum + vehicleExotique.value);
    totalAssets += jewelries.fold(0.0, (sum, jewelry) => sum + jewelry.value);
    totalAssets += antiques.fold(0.0, (sum, antique) => sum + antique.value);

    double totalDebt = bankAccounts.fold(0.0, (sum, acc) => sum + acc.totalDebt());

    return totalAssets - totalDebt;
  }

  double estimateEducationCost(EducationLevel education) {
    return FinancialService.adjustCost(education.cost);
  }

  double calculateMonthlyExpenses() {
    double totalExpenses = 0.0;

    // Coût des biens immobiliers
    totalExpenses += realEstates.fold(0.0, (sum, estate) => sum + estate.monthlyMaintenanceCost);

    // Coût des véhicules
    totalExpenses += vehicles.fold(0.0, (sum, vehicle) => sum + vehicle.monthlyFuelCost);
    totalExpenses += vehiculeExotiques.fold(0.0, (sum, vehicle) => sum + vehicle.monthlyFuelCost);

    // Coût des autres dépenses mensuelles (nourritures, éducation, etc.)
    totalExpenses += bankAccounts.fold(0.0, (sum, account) => sum + account.monthlyExpenses);

    return totalExpenses;
  }

  void addLifeHistoryEvent(LifeHistoryEvent event) {
    lifeHistory.add(event);
    print("Life event added: ${event.description}");
  }

  void updateFinancialStatus(double amount) {
    if (bankAccounts.isNotEmpty) {
      bankAccounts.first.deposit(amount);
      print("${name}'s financial status updated by \$${amount.toStringAsFixed(2)}");
    } else {
      print("${name} has no bank accounts to update financial status.");
    }
  }

  void updateRelationship(String targetParsonId, int impact) {
    if (relationships.containsKey(targetParsonId)) {
      relationships[targetParsonId]!.quality += impact;
      relationships[targetParsonId]!.quality = relationships[targetParsonId]!.quality.clamp(0.0, 100.0);
      print("Relationship with $targetParsonId updated. New quality: ${relationships[targetParsonId]!.quality}");
    } else {
      print("No relationship found with person $targetParsonId.");
    }
  }
  double calculateMortalityRisk() {
    // Exemple d'une espérance de vie moyenne de 80 ans
    double lifeExpectancy = 80.0;

    // La probabilité de mort augmente exponentiellement après un certain âge
    if (age < lifeExpectancy) {
      return 0.01 * (age / lifeExpectancy); // Par exemple, 1% de risque par année avant l'espérance de vie
    } else {
      return 0.05 * ((age - lifeExpectancy) / 10); // Augmente significativement après l'espérance de vie
    }
  }

  void checkForDeath() {
    double mortalityRisk = calculateMortalityRisk();
    if (Random().nextDouble() < mortalityRisk) {
      die();
    }
  }

  void die() {
    print("$name has died at the age of $age");

    if (children.isNotEmpty) {
      Person heir = children.first;
      heir.inheritFrom(this);

      // Convertir le parent décédé en PNJ
      this.becomeNPC();

      // Gérer les relations avec les grands-parents
      heir.parents.addAll(this.parents);

      // Assurer que l'ancien parent reste dans la relation de l'enfant
      heir.parents.add(this);

      print("Assets have been distributed among the children");
    } else if (partners.isNotEmpty) {
      partners.first.inheritFrom(this);
      print("Assets have been inherited by the partner.");
    } else {
      print("No direct heirs, assets are unclaimed.");
    }
  }


  void becomeNPC() {
    // Changer l'état du personnage pour ne plus être controlé directement
    print("$name devient un PNJ après sa mort.");
    // Arreter certain action etc etc
  }

  Person createChild(Person partner) {
    // Générez des caractéristiques pour l'enfant (nom, genre, apparence, etc)
    String childName = "Child of ${name} and ${partner.name}";
    String gender = Random().nextBool() ? 'Male': 'Female';
    double appearance = (this.appearance + partner.appearance) / 2;
    double health = (this.health + partner.health) / 2;
    double karma = 100.0;
    double happiness = 100.0;

    Person child = Person(
      name: childName,
      gender: gender,
      country: this.country,
      appearance: appearance,
      intelligence: intelligence,
      health: health,
      happiness: happiness,
      karma: karma,
      age: 0,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [],
      offshoreAccounts: [],
      parents: [this, partner],
      partners: [],
      skills: {},
    );

    // Ajouter l'enfant aux listes des parents
    this.children.add(child);
    partner.children.add(child);

    return child;
  }
}
