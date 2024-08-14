import 'dart:math';

import 'package:bit_life_like/services/bank/FinancialService.dart';

class Event {
  String name;
  String description;
  Map<String, dynamic> effects; // Effects on the person
  double probability; // Probability of occurrence
  Map<String, Map<String, dynamic>>? choices;

  Event({
    required this.name,
    required this.description,
    required this.effects,
    required this.probability,
    this.choices,
  });

  void simulateRandomInflation() {
    final random = Random();
    double change = random.nextDouble() * 0.05; // jusqu'à 5% de variation
    bool isInflation = random.nextBool();

    double newRate = FinancialService.applyInflation(FinancialService.inflationRate + (isInflation ? change : -change));
    FinancialService.updateInflationRate(newRate.clamp(-0.05, 0.1));

    print("New Inflation Rate : ${(FinancialService.inflationRate * 100).toStringAsFixed(2)}%");
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      description: json['description'],
      effects: json['effects'],
      probability: json['probability'],
      choices: json['choices'],
    );
  }
}
