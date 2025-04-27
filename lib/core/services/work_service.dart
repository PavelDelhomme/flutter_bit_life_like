
import 'package:bitlife_like/plugins/career_plugins/work_system/models/joboffer.dart';

import '../../plugins/career_plugins/work_system/models/career.dart';
import '../models/character.dart';

class WorkService {
  static final WorkService _instance = WorkService._internal();
  factory WorkService() => _instance;
  WorkService._internal();

  List<JobOffer> generateJobOffers() {
    return [
      JobOffer(title: 'Ingénieur', salary: 40000),
      JobOffer(title: 'Médecin', salary: 50000),
      JobOffer(title: 'Consultant', salary: 45000),
      JobOffer(title: 'Commercial', salary: 30000),
    ];
  }

  void applyForJob(Character character, JobOffer jobOffer) {
    character.career = Career(
      id: 'career_${DateTime.now().millisecondsSinceEpoch}',
      characterId: character.id,
      companyName: "Entreprise ${jobOffer.title}",
      jobTitle: jobOffer.title,
      salary: jobOffer.salary,
      bonusRate: 0.1,
    );
  }
}