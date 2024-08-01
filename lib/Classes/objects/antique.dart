import 'collectible_item.dart';

class Antique extends CollectibleItem {
  Antique({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
  }) : super(
      name: name,
      value: value,
      rarity: rarity,
      epoch: epoch
  );

  @override
  String display() {
    return 'Antique: $name, Epoch: $epoch, Value: $value, Rarity: $rarity';
  }
}
