import 'dart:math'; // Ajoutez cette ligne pour les valeurs aléatoires
import 'package:bit_life_like/screens/work/classes/business.dart';

class BusinessService {
  final Random _random = Random();

  void manageBusiness(Business business) {
    // Générer un revenu aléatoire pour l'année, basé sur la taille de l'entreprise ou d'autres facteurs
    double randomRevenue = _generateRandomIncome(business);

    // Simulez la génération de revenus
    business.generateIncome(randomRevenue);

    // Gérer les autres opérations de l'entreprise
    business.paySalaries();
    business.applyAmortization();
    business.handleAudit();
    business.payTaxes();
    business.calculateAnnualProfit();

    print("${business.name}'s annual operation completed.");
  }

  // Méthode pour générer un revenu aléatoire basé sur certains paramètres de l'entreprise
  double _generateRandomIncome(Business business) {
    // Ici, vous pouvez simuler des revenus aléatoires en fonction de la taille de l'investissement initial
    // ou du type d'entreprise. Pour le moment, nous utiliserons simplement une valeur aléatoire.
    double minIncome = business.initialInvestment * 0.5; // Revenu minimum = 50% de l'investissement initial
    double maxIncome = business.initialInvestment * 1.5; // Revenu maximum = 150% de l'investissement initial

    // Retourner une valeur aléatoire comprise entre minIncome et maxIncome
    return minIncome + _random.nextDouble() * (maxIncome - minIncome);
  }
}
