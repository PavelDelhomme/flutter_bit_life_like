import '../../models/asset/assets.dart';
import '../../models/person/character.dart';

class TransactionService {
  static void transferAsset(Asset asset, Character from, Character to) {
    asset.transferOwnership(to.id);
    from.assets.remove(asset);
    to.assets.add(asset);

    from.addLifeEvent("A transféré ${asset.name} à ${to.fullName}");
    to.addLifeEvent("A reçu ${asset.name} de ${from.fullName}");
  }

  static void sellAsset(Asset asset, Character seller, Character buyer, double price) {
    if (buyer.money >= price) {
      transferAsset(asset, seller, buyer);
      buyer.money -= price;
      seller.money += price;
    }
  }
}
