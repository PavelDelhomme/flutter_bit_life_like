import 'dart:math';

import '../objects/collectible_item.dart';

class TaxSystem {
  final double personalIncomeTaxBaseRate = 0.1; // Taux de base d'imposition

  final List<Map<String, dynamic>> incomeTaxBrackets = [
    {'limit': 20000, 'rate': 0.1},      // 10% jusqu'à 20 000
    {'limit': 40000, 'rate': 0.15},     // 15% jusqu'à 40 000
    {'limit': 80000, 'rate': 0.2},      // 20% jusqu'à 80 000
    {'limit': 160000, 'rate': 0.3},     // 30% jusqu'à 160 000
    {'limit': 320000, 'rate': 0.45},    // 45% jusqu'à 320 000
    {'limit': 640000, 'rate': 0.55},    // 55% jusqu'à 640 000
    {'limit': 1320000, 'rate': 0.6},    // 60% jusqu'à 1 320 000
    {'limit': 1960000, 'rate': 0.65},   // 65% jusqu'à 1 960 000
    {'limit': 3280000, 'rate': 0.67},   // 67% jusqu'à 3 280 000
    {'limit': 5240000, 'rate': 0.71},   // 71% jusqu'à 5 240 000
    {'limit': 8520000, 'rate': 0.73},   // 73% jusqu'à 8 520 000
    {'limit': 13760000, 'rate': 0.75},  // 75% jusqu'à 13 760 000
    {'limit': 22280000, 'rate': 0.79},  // 79% jusqu'à 22 280 000
    {'limit': 36040000, 'rate': 0.82},  // 82% jusqu'à 36 040 000
    {'limit': 58320000, 'rate': 0.85},  // 85% jusqu'à 58 320 000
    {'limit': double.infinity, 'rate': 0.9}, // 90% pour tout ce qui dépasse 58 320 000
  ];

  final double corporateTaxRate = 0.25; // Taux d'imposition pour les entreprises

  final double wealthTaxRate = 0.1;
  final double wealthThreshold = 500000; // Seuil pour être taxé syr ka fortune

  // Taxe sur les bien de luxe
  final double luxuryTaxRate = 0.15; // 15% sur les biens de luxe


  double calculatePersonalTax(double annualIncome) {
    double totalTaxes = 0.0;

    for (var bracket in incomeTaxBrackets) {
      if (annualIncome > bracket['limit']) {
        double taxableAmount = min<double>(
            annualIncome,
            bracket['limit'] as double
        ) - (incomeTaxBrackets.indexOf(bracket) > 0 ? incomeTaxBrackets[incomeTaxBrackets.indexOf(bracket) - 1]['limit'] as double : 0.0);
        totalTaxes += taxableAmount * bracket['rate'];
      } else {
        break;
      }
    }
    return totalTaxes;
  }


  double calculateCorporateTax(double businessIncome) {
    return businessIncome * corporateTaxRate;
  }

  double calculateWealthTax(double netWorth) {
    if (netWorth > wealthThreshold) {
      return (netWorth - wealthThreshold) * wealthTaxRate;
    }
    return 0.0;
  }

  double calculateLuxuryTax(List<CollectibleItem> luxuryItems) {
    return luxuryItems.fold(0.0, (sum, item) => sum + (item.value * luxuryTaxRate));
  }



}