import 'dart:math';
import '../models/character.dart';

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

  void performAnnualAction(Character pnj) {
    // Exemple
    if (pnj.age > 60 && _shouldTakeAction(0.2)) {
      pnj.addLifeEvent("Je pense à la retraite...");
    }

    // TODO: Appels à plugins
  }

}
