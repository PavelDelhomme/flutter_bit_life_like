import 'package:bitlife_like/core/shared/company_service.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/models/career.dart';
import '../models/character.dart';
import '../../plugins/career_plugins/work_system/models/joboffer.dart';

class WorkService {
  static final WorkService _instance = WorkService._internal();
  factory WorkService() => _instance;
  WorkService._internal();

  void applyForJob(Character character, JobOffer jobOffer) {
    final company = CompanyService.instance.findCompanyByName(jobOffer.company);

    if (company == null) {
      throw Exception("Entreprise ${jobOffer.company} introuvable !");
    }

    character.career = Career(
      id: 'career_${DateTime.now().millisecondsSinceEpoch}',
      characterId: character.id,
      companyName: company.name,
      jobTitle: jobOffer.title,
      salary: jobOffer.salary,
      bonusRate: 0.1,
      status: EmploymentStatus.fullTime,
    );
  }
}
