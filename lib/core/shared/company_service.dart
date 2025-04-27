import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../plugins/career_plugins/entreprise/models/business.dart';


class CompanyService {
  static final CompanyService _instance = CompanyService._internal();
  static CompanyService get instance => _instance;

  final List<Business> _companies = [];
  final Random _random = Random();

  CompanyService._internal();

  Future<void> initialize() async {
    final String data = await rootBundle.loadString('assets/data/company_catalog.json');
    final Map<String, dynamic> jsonData = json.decode(data);

    jsonData.forEach((country, companies) {
      for (final company in companies) {
        _companies.add(
            Business(
              name: company['name'],
              industry: company['industry'],
              capital: (company['startingCapital'] as num).toDouble(),
              country: country,
              valuation: (company['startingCapital'] as num).toDouble() * 1.5,
            )
        );
      }
    });
  }

  List<Business> get companies => _companies;

  void simulateYearlyEvolution() {
    for (var company in _companies) {
      // Croissance aléatoire de 5% à 20%
      double growthRate = 0.05 + _random.nextDouble() * 0.15;
      company.valuation *= (1 + growthRate);

      // Dépenses et revenus
      double profit = company.calculateMonthlyProfit() * 12;
      company.capital += profit;

      // Possibilité de faillite si capital < 0
      if (company.capital < 0) {
        company.capital = 0;
        // TODO: Gestion faillite
      }
    }
  }

  Business? findCompanyByName(String name) {
    return _companies.firstWhere((c) => c.name == name, orElse: () => null);
  }

  List<Business> getCompaniesInCountry(String country) {
    return _companies.where((c) => c.country == country).toList();
  }

  void addCompany(Business business) {
    _companies.add(business);
  }
}
