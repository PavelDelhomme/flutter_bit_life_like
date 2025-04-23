import 'package:bitlife_like/core/models/character.dart';
import '../models/career.dart';
import 'dart:math';

import '../models/job_offre.dart';

class JobMarketService {
  static final JobMarketService _instance = JobMarketService._internal();
  static JobMarketService get instance => _instance;

  JobMarketService._internal();

  final List<JobOffer> _offers = List.generate(6, (index) {
    return JobOffer(
      id: "job_$index",
      title: ["Développeur", "Médecin", "Infirmier", "Professeur", "Livreur", "Commercial"][index],
      companyName: ["Tech Corp", "MédiSanté", "Clinique Bio", "Lycée Victor Hugo", "SpeedEx", "Sales4U"][index],
      salary: 24000.0 + Random().nextDouble(),
    );
  });

  List<JobOffer> getAvailableJobs(Character character) {
    // À améliorer plus tard avec filtres/diplômes
    return _offers;
  }

  void applyToJob(Character character, JobOffer offer) {
    final newCareer = Career(
      id: 'career_${DateTime.now().millisecondsSinceEpoch}',
      characterId: character.id,
      companyName: offer.companyName,
      jobTitle: offer.title,
      salary: offer.salary,
    );

    character.career = newCareer;
    character.addLifeEvent("J'ai obtenu un poste chez ${offer.companyName} en tant que ${offer.title} !");
  }
}
