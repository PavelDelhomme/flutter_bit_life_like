import 'package:bit_life_like/services/bank/bank_account.dart';

abstract class CollectibleItem implements Purchasable {
  late String name;
  late String rarity;
  late String epoch;

  @override
  final double value;

  CollectibleItem({
    required this.name,
    required this.value,
    required this.rarity,
    required this.epoch,
  });

  String display();
}