import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Jewelry extends CollectibleItem implements Purchasable {
  final String brand;
  final double carat;
  final double value;

  Jewelry({
    required String name,
    required this.value,
    required String rarity,
    required String epoch,
    required this.brand,
    required this.carat,
  }) : super(
    name: name,
    value: value,
    rarity: rarity,
    epoch: epoch,
  );

  factory Jewelry.fromJson(Map<String, dynamic> json) {
    return Jewelry(
      name: json['nom'].toString() ?? "Unknown",
      value: (json['valeur'] as num).toDouble() ?? 0.0,
      rarity: json['rarete'] ?? "Unknown",
      epoch: json['epoch'] ?? "Unknown",
      brand: json['marque'] ?? "Unknown",
      carat: (json['carat'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nom": name,
      "valeur": value,
      "rarete": rarity,
      "epoch": epoch,
      "marque": brand,
      "carat": carat,
    };
  }

  @override
  String display() {
    return 'Jewelry: $name, Brand: $brand, Value: \$${value.toString()}, Rarity: $rarity, Carat: $carat';
  }
}
