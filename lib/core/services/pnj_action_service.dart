import '../models/character.dart';

class PnjActionService {
  static final _instance = PnjActionService._internal();
  static PnjActionService get instance => _instance;

  PnjActionService._internal();


  void performDailyActions(Character pnj) {
    if (!pnj.isAlive) return;

    // Exemple : chercher du travail, déménager, se marier, etc.
    if (pnj.age >= 18 && pnj.career == null && _shouldTakeAction(0.3)) {
      pnj.addLifeEvent("J'ai commencé à chercher un emploi.");
      // Ajout logique métier future ici
    }

    if (_shouldTakeAction(0.2)) {
      pnj.stats['happiness'] = (pnj.stats['happiness']! + 5).clamp(0, 100);
    }

    // TODO : plugins pourront intercepter ce moment
  }

  void performAnnualAction(Character pnj) {
    if (!pnj.isAlive) return;

    // Exemple : chercher du travail, déménager, se marier, etc.
    if (pnj.age >= 18 && pnj.career == null && _shouldTakeAction(0.3)) {
      pnj.addLifeEvent("J'ai commencé à chercher un emploi.");
      // Ajout logique métier future ici
    }

    if (_shouldTakeAction(0.2)) {
      pnj.stats['happiness'] = (pnj.stats['happiness']! + 5).clamp(0, 100);
    }

    // TODO : plugins pourront intercepter ce moment
  }

  bool _shouldTakeAction(double chance) => (chance > 0 && chance >= (DateTime.now().millisecond % 100) / 100.0);
}
