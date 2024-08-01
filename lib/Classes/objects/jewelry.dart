import 'collectible_item.dart';

class Jewelry extends CollectibleItem {
  String brand;
  double carat;

  Jewelry({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
    required this.brand,
    required this.carat,
  }) : super(
      name: name,
      value: value,
      rarity: rarity,
      epoch: epoch
  );

  @override
  String display() {
    return 'Jewelry: $name, Brand: $brand, Value: $value, Rarity: $rarity, Carat: $carat';
  }
}
