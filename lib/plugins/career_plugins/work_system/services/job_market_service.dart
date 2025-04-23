import 'package:bitlife_like/core/models/character.dart';
import '../models/career.dart';

class JobMarketService {
  static final JobMarketService _instance = JobMarketService._internal();
  static JobMarketService get instance => _instance;

  JobMarketService._internal();

  final List<Career> _availableJobs = [
    Career(jobTitle: "Développeur Junior", annualSalary: 30000),
    Career(jobTitle: "Caissier", annualSalary: 22000),
    Career(jobTitle: "Infirmier", annualSalary: 28000),
    Career(jobTitle: "Enseignant", annualSalary: 27000),
    Career(jobTitle: "Consultant", annualSalary: 40000),
  ];

  List<Career> getJobsForCharacter(Character character) {
    return _availableJobs; // plus tard : filtrage selon diplômes, compétences
  }

  void applyToJob(Character character, Career job) {
    character.career = job;
    character.addLifeEvent("J'ai obtenu un emploi comme ${job.jobTitle} !");
  }
}
