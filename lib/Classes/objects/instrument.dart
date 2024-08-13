import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Instrument extends CollectibleItem implements Purchasable {
  final String type; // Par exemple: Cordes, Percussion, Vent, etc.

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

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'rarity': rarity,
      'epoch': epoch,
      'type': type,
    };
  }
}
