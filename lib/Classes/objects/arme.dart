import 'package:bit_life_like/Classes/objects/collectible_item.dart';

class Arme extends CollectibleItem {
  String type;

  Arme({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
    required this.type,
}) : super(
    name: name,
    value: value,
    rarity: rarity,
    epoch: epoch
  );

  @override
  String display() {
    return "$name ($type) - Epoch: $epoch, Value: \$$value, Rarity: $rarity";
  }
}