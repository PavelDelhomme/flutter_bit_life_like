import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Arme extends CollectibleItem implements Purchasable {
  final String type;
  final double value;

  Arme({
    required String name,
    required this.value,
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
