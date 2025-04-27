import 'dart:math';

import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/data_service.dart';
import 'package:bitlife_like/core/shared/company_service.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/models/joboffer.dart';

class JobOfferService {
  static final JobOfferService _instance = JobOfferService._internal();
  factory JobOfferService() => _instance;
  JobOfferService._internal();

  final Random _random = Random();
  Map<String, List<Map<String, dynamic>>> _jobCatalog = {};

  double _crisisFactor = 1.0;
  final Map<String, double> _industryBoost = {};

  void applyCrisisModifier(double factor) {
    _crisisFactor = factor;
  }

  void applyIndustryBoost(String industry, double boost) {
    _industryBoost[industry] = boost;
  }

  Future<void> loadJobCatalog() async {
    _jobCatalog = await DataService.loadJobCatalog();
  }

  List<JobOffer> generateJobOffers(Character character) {
    final List<JobOffer> offers = [];

    final allCompanies = CompanyService.instance.companies.where((c) => !c.isGovernmentOwned).toList();
    if (allCompanies.isEmpty || _jobCatalog.isEmpty) return offers;

    int numberOfOffers = 3 + _random.nextInt(3);

    for (int i = 0; i < numberOfOffers; i++) {
      final company = allCompanies[_random.nextInt(allCompanies.length)];
      final industry = company.industries.isNotEmpty ? company.industries.first : 'Divers';

      final jobsInIndustry = _jobCatalog[industry] ?? _randomFallbackJobs();
      final jobData = jobsInIndustry[_random.nextInt(jobsInIndustry.length)];

      double salary = _randomSalary(jobData['minSalary'], jobData['maxSalary']);

      if (_industryBoost.containsKey(industry)) {
        salary *= (1 + _industryBoost[industry]!);
      }
      salary *= _crisisFactor;


      offers.add(JobOffer(
        title: jobData['title'],
        salary: salary,
        company: company.name,
      ));
    }

    return offers;
  }

  List<Map<String, dynamic>> _randomFallbackJobs() {
    // Si pas d'industrie associée
    return [
      {"title": "Employé polyvalent", "minSalary": 20000, "maxSalary": 40000},
      {"title": "Assistant administratif", "minSalary": 25000, "maxSalary": 45000},
    ];
  }

  double _randomSalary(num min, num max) {
    return min.toDouble() + _random.nextInt((max.toDouble() - min.toDouble()).toInt());
  }
}
