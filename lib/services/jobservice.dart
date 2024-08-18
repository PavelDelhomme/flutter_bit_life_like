import 'dart:math';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/job.dart';
import 'pnj_service.dart';

class JobService {
  final PnjService pnjService = PnjService();

  void applyForJob(Person person, Job job) {
    // Ajouter l'emploi à la personne
    person.jobs.add(job);

    // Générer un nombre aléatoire de collègues entre 5 et 30
    job.colleagues = pnjService.generateColleagues(person.country, Random().nextInt(26) + 5);

    // Afficher un message pour indiquer que la personne a obtenu l'emploi
    print("${person.name} a été embauché(e) comme ${job.title} chez ${job.companyName} avec ${job.colleagues.length} collègues.");
  }

  List<Job> loadJobs() {
    // Charger une liste d'emplois disponibles
    return [
      Job(title: 'Software Engineer', country: 'USA', salary: 80000, hoursPerWeek: 40, companyName: 'TechCorp', isFullTime: true),
      Job(title: 'Doctor', country: 'France', salary: 90000, hoursPerWeek: 45, companyName: 'HealthCare Inc.', isFullTime: true),
    ];
  }
}
