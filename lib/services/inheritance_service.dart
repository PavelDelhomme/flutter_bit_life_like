
import 'package:bitlife_like/models/person/character.dart';

class InheritanceService {
  static void transfertAssets(Character deceased, Character heir) {
    final inheritanceTax = deceased.legalSystem?.inheritanceTaxRate ?? 0.3;

    // Transfert d'argent
    heir.money += deceased.money * (1 - inheritanceTax);

    // Transfert de possessions
    heir.assets.addAll(deceased.assets.map((assets) {
      assets.transferOwnership(heir.id);
      return assets;
    }));
  }
}