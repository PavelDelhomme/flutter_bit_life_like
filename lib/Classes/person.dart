import '../services/band_account.dart';
import 'job.dart';
import 'vehicle.dart';
import 'vehicle_collection.dart';

class Person {
  String name;
  String gender;
  String country;
  int age = 0;
  BankAccount bankAccount;

  // Work
  List<Job> jobs = [];

  // Studies
  List<Etude> etudes = [];

  List<Moto> motos = [];
  List<Voiture> voitures = [];
  List<Bateau> bateaux = [];
  List<Avion> avions = [];
  List<VehiculeExotique> vehicules_exotiques = [];
  List<VoitureDeCollection> collections_voitures = [];
  List<MotoDeCollection> collections_motos = [];
  List<BateauDeCollection> collections_bateaux = [];
  List<AvionDeCollection> collections_avions = [];

  Person({required this.name, required this.gender, required this.country, required this.bankAccount});

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
