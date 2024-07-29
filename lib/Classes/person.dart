import 'package:bit_life_like/Classes/job.dart';

class Person {
  String namme;
  String gender;
  String country;
  int age = 0;
  double bankAccount = 0;

  // Work
  List<Job> jobs = [];

  // Studies
  List<Etudes> etudes = [];

  List<Motos> motos = [];
  List<Voitures> voitures = [];
  List<Bateaux> bateaux = [];
  List<Avions> avions = [];
  List<VehiculesExotiquzes> vehicules_exotiques = [];
  List<VoituresDeCollections> collections_voitures = [];
  List<MotosDeCollections> collections_motos = [];
  List<BateauxDeCollections> collections_bateaux = [];
  List<AvionsDeCollections> collections_avions = [];

  Person({required this.name, required this.gender, required this.country});

  void ageOneYear() {
    age += 1;
    for (var job in jobs) {
      job.workSemester();
    }
  }

  void retire(Job job) {
    jobs.remove(job);
  }
}