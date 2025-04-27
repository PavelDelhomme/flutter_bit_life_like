import 'dart:math';

import '../models/company.dart';
import '../services/data_service.dart';

class CompanyService {
  static final CompanyService _instance = CompanyService._internal();
  static CompanyService get instance => _instance;
  CompanyService._internal();

  final List<Company> _companies = [];
  final Random _random = Random();

  List<Company> get companies => _companies;

  Future<void> initialize() async {
    // Charger le fichier company_catalog.json
    final catalog = await DataService.loadCompanyCatalog();

    for (final entry in catalog.entries) {
      final country = entry.key;
      for (final companyData in entry.value) {
        final taxSystem = await DataService.loadTaxSystem(country);
        final city = await DataService.getRandomCityForCountry(country);

        _companies.add(
            Company(
              id: 'comp_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}',
              name: companyData['name'],
              country: country,
              cities: [city],
              industries: [companyData['industry']],
              type: CompanyType.corporation,
              size: _estimateCompanySize(companyData['startingCapital']),
              capital: (companyData['startingCapital'] as num).toDouble(),
              valuation: (companyData['startingCapital'] as num).toDouble() * 1.5,
              revenue: (companyData['startingCapital'] as num).toDouble() * 0.8,
              expenses: (companyData['startingCapital'] as num).toDouble() * 0.6,
              employees: [],
              products: [],
              marketShare: _random.nextDouble() * 0.1,
              publicReputation: 50 + _random.nextDouble() * 50,
              taxSystem: taxSystem,
              currentLaws: [],
              legalSystems: [],
              loans: [],
              hasIPO: false,
              stockPrice: 0,
              tradePartners: [],
              companyPartners: [],
              politicalInfluence: _random.nextDouble() * 10,
              complianceScore: 70 + _random.nextDouble() * 30,
              isUnderInvestigation: false,
              riskOfBankruptcy: 0.01,
              growthRate: 0.05 + _random.nextDouble() * 0.10,
              researchInvestment: _random.nextDouble() * 1000000,
              sustainabilityScore: 50 + _random.nextDouble() * 50,
              isGovernmentOwned: false,
              acquiredCompanies: [],
            )
        );
      }
    }
  }

  CompanySize _estimateCompanySize(double startingCapital) {
    if (startingCapital < 50000) return CompanySize.micro;
    if (startingCapital < 500000) return CompanySize.petite;
    if (startingCapital < 5000000) return CompanySize.moyenne;
    if (startingCapital < 50000000) return CompanySize.grande;
    if (startingCapital < 500000000) return CompanySize.geante;
    if (startingCapital < 1000000000) return CompanySize.immense;
    return CompanySize.impossible;
  }

  void simulateYearlyEvolution() {
    for (final company in _companies) {
      if (company.isGovernmentOwned) continue;

      _simulateGrowth(company);
      _simulateExpenses(company);
      _simulateBankruptcy(company);
      _simulateAcquisitions(company);
      _simulateIPO(company);
    }
  }


  void _simulateGrowth(Company company) {
    double growth = company.growthRate + (_random.nextDouble() - 0.5) * 0.05;
    company.valuation *= (1 + growth);
    company.revenue *= (1 + growth);
  }

  void _simulateExpenses(Company company) {
    company.expenses *= (1 + (_random.nextDouble() - 0.5) * 0.1);
    double profit = company.revenue - company.expenses;
    company.capital += profit;
  }

  void _simulateBankruptcy(Company company) {
    if (company.capital < 0) {
      company.riskOfBankruptcy += 0.05;
      if (_random.nextDouble() < company.riskOfBankruptcy) {
        // Faillite
        _companies.remove(company);
        // TODO: Créer un événement de faillite dans l'historique mondial si besoin
      }
    }
  }

  void _simulateAcquisitions(Company company) {
    if (company.capital > company.valuation * 1.5 && _companies.length > 1) {
      final potentialTargets = _companies.where((c) => c != company && c.country == company.country && !c.isGovernmentOwned).toList();
      if (potentialTargets.isNotEmpty) {
        final target = potentialTargets[_random.nextInt(potentialTargets.length)];
        final acquisitionCost = target.valuation * (1.1 + _random.nextDouble() * 0.2);

        if (company.capital >= acquisitionCost) {
          company.capital -= acquisitionCost;
          company.valuation += target.valuation * 0.8;
          company.revenue += target.revenue;
          company.marketShare += target.marketShare * 0.5;
          company.acquiredCompanies.add(target);
          _companies.remove(target);

          // Life Event
          // TODO: déclencher un GameEvent futur si tu veux afficher "Fusion : [company] a acquis [target]"
        }
      }
    }
  }


  void _simulateIPO(Company company) {
    if (!company.hasIPO && company.valuation > 100000000) {
      company.hasIPO = true;
      company.stockPrice = company.valuation / 1000000;
    }
  }

  Company? findCompanyByName(String name) {
    try {
      return _companies.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  List<Company> getCompaniesInCountry(String country) {
    return _companies.where((c) => c.country == country).toList();
  }

  void addCompany(Company company) {
    _companies.add(company);
  }
}
