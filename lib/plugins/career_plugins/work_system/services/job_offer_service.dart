import 'dart:math';

import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/plugins/career_plugins/entreprise/services/business_service.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/models/joboffer.dart';

import '../../../../core/models/company.dart';
import '../../../../core/shared/company_service.dart';


class JobOfferService {
  static final JobOfferService _instance = JobOfferService._internal();
  factory JobOfferService() => _instance;
  JobOfferService._internal();

  final Random _random = Random();


  // Générer une liste d'offres d'emploi
  List<JobOffer> generateJobOffers(Character character) {
    final List<JobOffer> offers = [];
    final allCompanies = CompanyService.instance.companies.where((c) => !c.isGovernmentOwned).toList();

    if (allCompanies.isEmpty) {
      return offers;
    }

    // Génère 3 à 5 offres
    int numberOfOffers = 3 + _random.nextInt(3);


    for (int i = 0; i < numberOfOffers; i++) {
      final company = allCompanies[_random.nextInt(allCompanies.length)];
      final title = _randomJobTitle();
      final salary = _estimateSalary(company);

      offers.add(JobOffer(
        title: title,
        salary: salary,
        company: company.name,
      ));
    }

    return offers;
  }

  String _randomJobTitle() {
    final titles = [
      "Développeur",
      "Chef de projet",
      "Analyste financier",
      "Commercial",
      "Designer",
      "Ingénieur mécanique",
      "Marketing Specialist",
    ];
    return titles[_random.nextInt(titles.length)];
  }


  double _estimateSalary(Company company) {
    double base = (25000 + _random.nextInt(50000)) as double;
    double factor = 1 + (company.size.index * 0.2); // Plus l'entreprise est grande, mieux payé
    return base * factor;
  }
}