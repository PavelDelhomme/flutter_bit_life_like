import 'dart:math';
import '../models/character.dart';

class PnjActionService {
  final Random _random = Random();

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
}
