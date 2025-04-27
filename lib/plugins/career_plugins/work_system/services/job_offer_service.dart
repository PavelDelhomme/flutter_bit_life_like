import 'dart:math';

import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/plugins/career_plugins/entreprise/services/business_service.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/models/joboffer.dart';


class JobOfferService {
  static final JobOfferService _instance = JobOfferService._internal();
  factory JobOfferService() => _instance;
  JobOfferService._internal();

  final Random _random = Random();


  // Générer une liste d'offres d'emploi
  List<JobOffer> generateJobOffers(Character character) {
    final List<JobOffer> offers = [];

    // Liste de métiers possibles (exemple de base)
    final jobTitles = [
      "Développeur",
      "Chef de projet",
      "Analyste financier",
      "Commercial",
      "Designer",
      "Ingénieur mécanique",
      "Marketing Specialist",
    ];

    // Génère 3 à 5 offres
    int numberOfOffers = 3 + _random.nextInt(3);

    for (int i = 0; i < numberOfOffers; i++) {
      final title = jobTitles[_random.nextInt(jobTitles.length)];
      final salary = 25000 + _random.nextInt(50000); // salaire entre 25k et 75k

      final companyName = _generateRandomCompanyName();

      // Crée une entreprise associée
      BusinessService.createCompany(character, companyName, _randomIndustry(), 50000 + _random.nextInt(50000));

      offers.add(JobOffer(
        title: title,
        salary: salary.toDouble(),
        company: companyName,
      ));
    }

    return offers;
  }

  // Générer un nom d'entreprise
  String _generateRandomCompanyName() {
    final prefixes = ["Global", "Nova", "Techno", "Alpha", "Prime", "Next", "Eco"];
    final suffixes = ["Corp", "Solutions", "Industries", "Group", "Systems"];

    return "${prefixes[_random.nextInt(prefixes.length)]} ${suffixes[_random.nextInt(suffixes.length)]}";
  }

  // Générer un secteur d'activité aléatoire
  String _randomIndustry() {
    final industries = ["Technologie", "Finance", "Immobilier", "Marketing", "Consulting"];
    return industries[_random.nextInt(industries.length)];
  }

}