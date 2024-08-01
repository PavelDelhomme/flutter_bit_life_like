import 'collectible_item.dart';

class Instrument extends CollectibleItem {
  String type;  // Par exemple: Cordes, Percussion, Vent, etc.

  Instrument({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
    required this.type,
  }) : super(
    name: name,
    value: value,
    rarity: rarity,
    epoch: epoch,
  );

  @override
  String display() {
    return "$name ($type) - Epoch: $epoch, Value: \$$value, Rarity: $rarity";
  }
}
