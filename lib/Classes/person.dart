import 'dart:math';

import 'package:bit_life_like/Classes/objects/arme.dart';
import 'package:bit_life_like/Classes/objects/collectible_item.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';
import 'package:bit_life_like/Classes/objects/vehicle_collection.dart';
import '../screens/work/classes/business.dart';
import '../screens/work/classes/education.dart';
import '../screens/work/classes/job.dart';
import '../services/bank/FinancialService.dart';
import '../services/bank/bank_account.dart';
import 'objects/antique.dart';
import 'objects/instrument.dart';

class Person {
  String name;
  String gender;
  String country;
  int age = 0;
  double health = 100.0;
  double appearance = 100.0;
  double karma = 100.0;
  double happiness = 100.0;
  double intelligence = 100.0;
  bool isImprisoned = false;
  int prisonTerm = 0;

  //Job? currentJob;
  double stressLevel = 0.0;

  List<BankAccount> bankAccounts;

  // People
  List<Person> parents = [];
  List<Person> friends = [];
  List<Person> partners = [];

  // Works
  List<Job> jobs = [];
  List<Business> businesses = [];

  // Education
  List<EducationLevel> educationHistory = [];
  EducationLevel? currentEducation;
  double academicPerformance = 0;

  List<CollectibleItem> collectibles = [];
  List<Arme> armes = [];
  List<Jewelry> jewelries = [];
  List<Antique> antiques = [];
  List<RealEstate> realEstates = [];
  List<Instrument> instruments = [];

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
  })
      : bankAccounts = bankAccounts ?? [],
        partners = partners ?? [],
        parents = parents ?? [];

  void ageOneYear() {
    age += 1;
    updateHealthAndHappiness();
    if (isImprisoned) {
      prisonTerm--;
      if (prisonTerm <= 0) {
        releaseFromPrison();
      }
    }
  }

  void openAccount(Bank bank, String accountType, double initialDeposit, {bool isJoint = false}) {
    double interestRate = bank.getInterestRate(accountType);

    try {
      BankAccount newAccount = bank.openAccount(accountType, initialDeposit, interestRate, isJoint: isJoint, partners: this.partners);
      bankAccounts.add(newAccount);
      print("Account opened at ${bank.name} with type $accountType, initial deposit \$${initialDeposit}");
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
    BankAccount? primaryAccount = bankAccounts.isNotEmpty ? bankAccounts.first : null;
    if (primaryAccount != null && primaryAccount.balance >= education.cost) {
      primaryAccount.balance -= education.cost;
      currentEducation = education;
      academicPerformance = 0;
      print("Enrolled in ${education.name} with fees paid from account ${primaryAccount.accountNumber}");
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

    BankAccount? primaryAccount = bankAccounts.isNotEmpty ? bankAccounts.first : null;
    if (primaryAccount != null) {
      double inheritanceAmount = deceased.bankAccounts.fold(0.0, (sum, acc) => sum + (acc.balance * 0.6)); // Assuming 40% tax
      primaryAccount.deposit(inheritanceAmount);
      print("${name} inherited \$${inheritanceAmount} and assets from ${deceased.name} into account ${primaryAccount.accountNumber}");
    } else {
      print("${name} inherited assets but has no bank account to receive funds.");
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
    double projectedRevenue = businesses.fold(0.0, (sum, bsn) => sum + bsn.getBalance());
    BankAccount? primaryAccount = bankAccounts.isNotEmpty ? bankAccounts.first : null;

    if (primaryAccount != null) {
      FinancialService financialService = FinancialService.instance;
      if (financialService.applyForLoan(primaryAccount, amount, termYears, projectedRevenue)) {
        primaryAccount.deposit(amount);
        print("Business loan of \$${amount} approved and deposited into account ${primaryAccount.accountNumber}");
      } else {
        print("Business loan application denied due to insufficient projected revenue or credit policies.");
      }
    } else {
      print("No account available for loan deposit.");
    }
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
    )
  }


  void workJob(Job job, int hoursWorked) {
    int regularHours = min(hoursWorked, job.hoursPerWeek);
    int overtimeHours = max(0, hoursWorked - job.hoursPerWeek);
    double overtimePay = job.calculateOvertimePay(overtimeHours);
    double regularPay = regularHours * job.salary;
    double totalPay = regularPay + overtimePay;
    print("Total pay for the week: \$${totalPay}");
  }



}
