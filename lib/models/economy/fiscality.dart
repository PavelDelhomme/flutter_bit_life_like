import 'dart:math';
import '../asset/real_estate.dart';
import '../person/character.dart';

class TaxSystem {
  final String country;
  final double incomeTaxRate;
  final double capitalGainsTaxRate;
  final double propertyTaxRate;
  final double inheritanceTaxRate;
  final double auditProbability;
  
  TaxSystem({
    required this.country,
    this.incomeTaxRate = 0.25,
    this.capitalGainsTaxRate = 0.20,
    this.propertyTaxRate = 0.01,
    this.inheritanceTaxRate = 0.30,
    this.auditProbability = 0.05,
  });
  
  double calculateIncomeTax(double income) {
    // Simulation de tranches d'imposition
    if (income < 10000) return 0;
    else if (income < 25000) return income * 0.15;
    else if (income < 50000) return income * 0.25;
    else if (income < 100000) return income * 0.35;
    else return income * 0.45;
  }
  
  double calculatePropertyTax(List<RealEstate> properties) {
    return properties.fold(0.0, (sum, property) => sum + (property.value * propertyTaxRate));
  }
  
  bool performAudit(Character character) {
    // Probabilité d'audit basée sur l'écart entre revenu déclaré et réel
    double discrepancy = (character.actualIncome - character.declaredIncome) / character.actualIncome;
    double auditChance = auditProbability + (discrepancy * 0.5);
    
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
}