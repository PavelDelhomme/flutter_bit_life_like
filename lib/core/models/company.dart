import 'dart:math';

import 'package:bitlife_like/core/shared/legal.dart';
import 'package:bitlife_like/core/shared/tax_system.dart';
import 'package:bitlife_like/plugins/career_plugins/entreprise/models/business.dart';

class Company {
  final String id;
  final String name;
  final String country; // Pays d'origin ou le siege social est implementer
  final List<String> cities; // Villes d'implementation
  final List<String> industries; // Secteur d'activitié doit pouvoir en avoir plusieur non ??
  final CompanyType type; // Status juridique donc Startup PME, Multinationnale
  final CompanySize size; // Taille de l'entreprise 'startup, petite, moyenne grandes, geante, multinationnal'
  late final double capital; // Capital disponible
  late final double valuation; // Valorisation estimée
  late final double revenue; // Revenus annuels
  late final double expenses; // Dépenses annuelles
  final List<Employee> employees; // Liste des employés
  final List<Product> products; // Produits ou service vendus doit pouvoir vendre des produits et des services
  final List<Company> acquiredCompanies; // Liste des entreprises fusionnées ou rachetées
  late final double marketShare; // Part de marché dans son secteur
  final double publicReputation; // Réputation gobal
  final TaxSystem taxSystem; // Taxes de l'entreprise
  final List<Law> currentLaws; // Lois influencant l'entreprise
  final List<LegalSystem> legalSystems; // Système legal qui influe sur l'entreprise
  final List<BusinessLoan> loans; // Prêt
  late final bool hasIPO; // Est coté en bourses ?
  late final double stockPrice; // Prix de l'action si côtée
  final List<String> tradePartners; // pays avec lesquels elle commerces
  final List<Company> companyPartners; // Entreprise avec lesquelles elle commerces
  final double politicalInfluence; // Influence politique (0-100)
  final double complianceScore; // Conformité légale (0-100)
  late final bool isUnderInvestigation; // Sous enquête judiciaire
  late final double riskOfBankruptcy; // Risque actuel de faillite (0-1)
  final double growthRate; // Taux de croissance annuelle (%)
  final double researchInvestment; // Investissements en R&D
  final double sustainabilityScore; // Score écologique (0-100)
  final bool isGovernmentOwned; // Est-ce une entreprise publique


  Company({
    required this.id,
    required this.name,
    required this.country,
    required this.cities,
    required this.industries,
    required this.type,
    required this.size,
    required this.capital,
    required this.valuation,
    required this.revenue,
    required this.expenses,
    required this.employees,
    required this.products,
    required this.marketShare,
    required this.publicReputation,
    required this.taxSystem,
    required this.currentLaws,
    required this.legalSystems,
    required this.loans,
    required this.hasIPO,
    required this.stockPrice,
    required this.tradePartners,
    required this.companyPartners,
    required this.politicalInfluence,
    required this.complianceScore,
    required this.isUnderInvestigation,
    required this.riskOfBankruptcy,
    required this.growthRate,
    required this.researchInvestment,
    required this.sustainabilityScore,
    required this.isGovernmentOwned,
    required this.acquiredCompanies,
  });

  /// 💰 Calcule le bénéfice net après taxes
  double calculateNetProfit() {
    double profit = revenue - expenses;
    double corporateTax = profit > 0 ? profit * taxSystem.corporateTaxRate : 0;
    return profit - corporateTax;
  }

  /// 📈 Simule une année de croissance
  void simulateGrowth() {
    double profit = calculateNetProfit();
    capital += profit;
    valuation *= (1 + growthRate);
    if (profit < 0) {
      riskOfBankruptcy += 0.05;
    } else {
      riskOfBankruptcy -= 0.02;
      riskOfBankruptcy = riskOfBankruptcy.clamp(0, 1);
    }
  }

  /// ⚡ Lance une IPO
  void goPublic() {
    if (!hasIPO && valuation > 50000000) {
      hasIPO = true;
      stockPrice = valuation / (1000000 + employees.length);
      capital += valuation * 0.2; // Levée de fonds
    }
  }

  /// ⚡ Déclare faillite
  void declareBankruptcy() {
    capital = 0;
    revenue = 0;
    employees.clear();
    loans.clear();
    isUnderInvestigation = true;
  }

  /// 🤝 Acquisition d'une autre entreprise
  void acquire(Company target) {
    valuation += target.valuation * 0.8;
    revenue += target.revenue;
    employees.addAll(target.employees);
    products.addAll(target.products);
  }

  /// 🌎 Fusion avec une autre entreprise
  void merge(Company other) {
    capital += other.capital;
    revenue += other.revenue;
    expenses += other.expenses;
    employees.addAll(other.employees);
    products.addAll(other.products);
    valuation += other.valuation;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'cities': cities,
      'industries': industries,
      'type': type.toString(),
      'size': size.toString(),
      'acquiredCompanies': acquiredCompanies,
      'capital': capital,
      'valuation': valuation,
      'revenue': revenue,
      'expenses': expenses,
      'marketShare': marketShare,
      'publicReputation': publicReputation,
      'hasIPO': hasIPO,
      'stockPrice': stockPrice,
      'tradePartners': tradePartners,
      'companyPartners': companyPartners,
      'politicalInfluence': politicalInfluence,
      'complianceScore': complianceScore,
      'isUnderInvestigation': isUnderInvestigation,
      'riskOfBankruptcy': riskOfBankruptcy,
      'growthRate': growthRate,
      'researchInvestment': researchInvestment,
      'sustainabilityScore': sustainabilityScore,
      'isGovernmentOwned': isGovernmentOwned,
    };
  }


  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      cities: List<String>.from(json['cities']),
      industries: List<String>.from(json['industries']),
      type: CompanyType.values.firstWhere((e) => e.toString() == json['type']),
      size: CompanySize.values.firstWhere((e) => e.toString() == json['size']),
      capital: (json['capital'] as num).toDouble(),
      valuation: (json['valuation'] as num).toDouble(),
      revenue: (json['revenue'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      employees: [], // À remplir si nécessaire
      products: [],  // À remplir si nécessaire
      marketShare: (json['marketShare'] as num).toDouble(),
      publicReputation: (json['publicReputation'] as num).toDouble(),
      taxSystem: TaxSystem(country: json['country']),
      currentLaws: [],
      legalSystems: [],
      loans: [],
      hasIPO: json['hasIPO'],
      stockPrice: (json['stockPrice'] as num).toDouble(),
      tradePartners: List<String>.from(json['tradePartners']),
      companyPartners: List<Company>.from(json['companyPartners']),
      politicalInfluence: (json['politicalInfluence'] as num).toDouble(),
      complianceScore: (json['complianceScore'] as num).toDouble(),
      isUnderInvestigation: json['isUnderInvestigation'],
      riskOfBankruptcy: (json['riskOfBankruptcy'] as num).toDouble(),
      growthRate: (json['growthRate'] as num).toDouble(),
      researchInvestment: (json['researchInvestment'] as num).toDouble(),
      sustainabilityScore: (json['sustainabilityScore'] as num).toDouble(),
      isGovernmentOwned: json['isGovernmentOwned'],
      acquiredCompanies: List<Company>.from(json['acquiredCompanies']),
    );
  }
}


enum CompanyType {
  AutoEntreprise,
  Startup,
  PME,
  ETI, // ENtreprise de taille intermédiaire
  Corporation,
  Multinationale,
  Conglomerat,
  Holding,
  Public,
  Cooperative,
  NGO, // ONG
  Megacorporation, // Pour les taills "impossibles"
}

enum CompanySize {
  auto, // Autoentrepreuneur
  micro, // <10 employés
  petite, // <50
  moyenne, // <250
  grande, // <1 000
  geante, // >1 000 && <10 000
  immense, // >10 000 && <1 000 000
  impossible, // >1 000 000 && <10 000 000
  impossible2, // >10 000 000 && <20 000 000
  impossible3, // >20 000 000 && <100 000 000
  impossible4, // >100 000 000 && <200 000 000
  impossible5, // >200 000 000 && <300 000 000
  impossible6, // >300 000 000 && <500 000 000
  impossible7, // >500 000 000 && <999 999 999
  impossible8, // >999 999 999 && <1 000 000 000
}


class Product {
  final String id;
  final String name;
  final double basePrice;
  final double productionCost;
  final double popularity; // 0 à 100
  final String category; // Ex: Technologie, Nourriture, Services

  Product({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.productionCost,
    required this.popularity,
    required this.category,
  });
}
