import 'dart:math';
import 'dart:convert';
import '../asset/real_estate.dart';
import '../person/character.dart';
import 'package:flutter/services.dart';

class TaxSystem {
  final String country;
  late List<IncomeTaxBracket> incomeTaxBrackets;
  late double vatRate;
  late double capitalGainsTaxRate;
  late double coporateTaxRate;
  late double propertyTaxRate;
  late double inheritanceTaxRate;
  late double transferTaxRate;
  late double primaryResidenceTaxRate;
  late double secondariesResidenceTaxRate;

  TaxSystem({required this.country}) {
    _loadTaxData();
  }

  Future<void> _loadTaxData() async {
    final data = await rootBundle.loadString('assets/tax_data.json');
    final taxData = json.decode(data)[country];

    incomeTaxBrackets = (taxData['incomeTax'] as List)
      .map((b) => IncomeTaxBracket(
        min: b['min'], max: b['max'] ?? double.infinity, rate: b['rate']))
      .toList();

    vatRate = taxData['vat'];
    capitalGainsTaxRate = taxData['capitalGains'];
    coporateTaxRate = taxData['corporateTax'];
    propertyTaxRate = taxData['propertyTax'];
    inheritanceTaxRate = taxData['inheritanceTax'];
    transferTaxRate = taxData['transferTax'];
    primaryResidenceTaxRate = taxData['primaryResidenceTaxRate'];
    secondariesResidenceTaxRate = taxData['secondariesResidenceTaxRate'];
  }

  double calculateIncomeTax(double income) {
    double tax = 0;
    for (var bracket in incomeTaxBrackets) {
      if (income > bracket.min) {
        double taxableInBracket = (income < bracket.max)
            ? income - bracket.min
            : bracket.max - bracket.min;
        tax += taxableInBracket * bracket.rate;
      }
    }
    return tax;
  }
  
  double calculatePropertyTax(List<RealEstate> properties) {
    return properties.fold(0.0, (sum, property) => sum + (property.value * propertyTaxRate));
  }
  
  bool performAudit(Character character) {
    // Probabilité d'audit basée sur l'écart entre revenu déclaré et réel
    double discrepancy = (character.actualIncome - character.declaredIncome) / character.actualIncome;
    double auditChance = character.auditProbability + (discrepancy * 0.5);
    
    bool isAudited = Random().nextDouble() < auditChance;
    if (isAudited && discrepancy > 0.1) {
      // Fraude détectée
      double fine = (character.actualIncome - character.declaredIncome) * 1.5;
      character.money -= fine;
      character.addLifeEvent("Contrôle fiscal : fraude détectée. Amende de \$${fine.toStringAsFixed(2)}");
      return true;
    }
    return false;
  }


  double calculateVAT(double amount) => amount * vatRate;

  double calculateTransferTax(double assetValue) => assetValue * transferTaxRate;

  double calculateCapitalGains(double profit) => profit * capitalGainsTaxRate;
}


class IncomeTaxBracket {
  final double min;
  final double max;
  final double rate;

  IncomeTaxBracket({required this.min, required this.max, required this.rate});
}