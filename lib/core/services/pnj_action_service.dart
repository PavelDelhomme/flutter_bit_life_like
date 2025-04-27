import 'dart:math';
import 'package:bitlife_like/core/services/work_service.dart';

import '../../plugins/career_plugins/work_system/services/job_offer_service.dart';
import '../models/character.dart';
import '../models/company.dart';
import '../shared/company_service.dart';
import '../system/probability_engine.dart';
import 'data_service.dart';

class PnjActionService {
  static final PnjActionService _instance = PnjActionService._internal();
  static PnjActionService get instance => _instance;

  PnjActionService._internal();

  final Random _random = Random();

  bool _shouldTakeAction(double chance) {
    return _random.nextDouble() < chance;
  }
  
  void performDailyActions(Character pnj) {
    if (!pnj.isAlive) return;

    if (_random.nextDouble() < 0.05) {
      pnj.addLifeEvent("J'ai fait une rencontre inattendue.");
    }

    if (_random.nextDouble() < 0.03) {
      pnj.stats['happiness'] = (pnj.stats['happiness']! + 2).clamp(0, 100);
    }

    // Possibilité d’ajouter : travail, crime, politique, achats, etc.
  }

  Future<void> performAnnualAction(Character pnj) async {
    if (!pnj.isAlive) return;

    if (pnj.age > 60 && _shouldTakeAction(0.2)) {
      pnj.addLifeEvent("Je pense à la retraite...");
    }

    if (_random.nextDouble() < 0.02) {
      await attemptStartCompany(pnj);
      pnj.addLifeEvent("J'ai fondé une nouvelle entreprise !");
    }
    if (pnj.career == null && _random.nextDouble() < 0.3) {
      final offers = JobOfferService().generateJobOffers(pnj);
      if (offers.isNotEmpty) {
        WorkService().applyForJob(pnj, offers.first);
        pnj.addLifeEvent("J'ai trouvé un emploi chez ${offers.first.company} en tant que ${offers.first.title}.");
      }
    }

    // TODO: Appels à plugins
  }
  Future<void> attemptStartCompany(Character pnj) async {
    final industries = [
      "Technologie", "Finance", "Marketing", "Agriculture", "Construction", "Transport", "Santé", "Éducation", "Artisanat"
    ];

    if (ProbabilityEngine().roll(0.01)) { // 1% par an
      final industry = ProbabilityEngine().randomValue(industries);
      final companyName = "${pnj.fullName.split(' ').last} ${industry.substring(0,3)}";

      final newCompany = Company(
          id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
          name: companyName,
          country: pnj.country,
          cities: [pnj.city],
          industries: [industry],
          type: CompanyType.startup,
          size: CompanySize.micro,
          capital: 30000 + Random().nextInt(70000).toDouble(),
          valuation: 50000,
          revenue: 10000,
          expenses: 8000,
          employees: [],
          products: [],
          marketShare: 0.01,
          publicReputation: 50,
          taxSystem: await DataService.loadTaxSystem(pnj.country),
          currentLaws: [],
    legalSystems: [],
    loans: [],
    hasIPO: false,
    stockPrice: 0,
    tradePartners: [],
    companyPartners: [],
    politicalInfluence: 0,
    complianceScore: 70,
    isUnderInvestigation: false,
    riskOfBankruptcy: 0.05,
    growthRate: 0.08,
    researchInvestment: 10000,
    sustainabilityScore: 60,
    isGovernmentOwned: false,
    acquiredCompanies: [],
    );

    CompanyService.instance.addCompany(newCompany);
    pnj.addLifeEvent("J'ai créé une nouvelle entreprise dans le secteur $industry !");
  }
  }

}
