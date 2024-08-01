import 'package:bit_life_like/Classes/education.dart';

import '../services/bank_account.dart';
import 'job.dart';
import 'vehicle.dart';
import 'vehicle_collection.dart';

class Person {
  String name;
  String gender;
  String country;
  int age = 0;
  bool isImprisoned = false;
  int prisonTerm = 0;
  BankAccount bankAccount;


  // Work
  List<Job> jobs = [];

  // Studies
  List<EducationLevel> etudes = [];
  List<EducationLevel> educationHistory;
  EducationLevel? currentEducation;
  double academicPerformance;

  List<Moto> motos = [];
  List<Voiture> voitures = [];
  List<Bateau> bateaux = [];
  List<Avion> avions = [];
  List<VehiculeExotique> vehicules_exotiques = [];
  List<VoitureDeCollection> collections_voitures = [];
  List<MotoDeCollection> collections_motos = [];
  List<BateauDeCollection> collections_bateaux = [];
  List<AvionDeCollection> collections_avions = [];

  Person({
    required this.name,
    required this.gender,
    required this.country,
    required this.bankAccount,
    this.educationHistory = const [],
    this.currentEducation,
    this.academicPerformance = 0
  });

  void ageOneYear() {
    age += 1;
    for (var job in jobs) {
      job.workSemester();
    }
    if (isImprisoned) {
      prisonTerm -= 1;
      if (prisonTerm <= 0) {
        releaseFromPrison();
      }
    }
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
    if (bankAccount.balance >= education.cost) {
      currentEducation = education;
      bankAccount.balance -= education.cost;
      academicPerformance = 0;
    } else {
      print("No enough money to enroll in ${education.name}");
    }
  }

  // Méthode pour passer à l'énne suivante ou diplôme
  void completeYear() {
    if (currentEducation != null) {
      academicPerformance += 10; // Simule l'amélioration des performances
      if (academicPerformance > 100) {
        educationHistory.add(currentEducation!);
        currentEducation = null; // Diplômé ou fin de cycle
      }
    }
  }
}
