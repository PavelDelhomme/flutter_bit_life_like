import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Jewelry {
  final String name;
  final double value;
  final String brand;
  final String material;
  final double carat;
  double condition;
  final bool isRare;

  Jewelry({
    required this.name,
    required this.value,
    required this.brand,
    required this.material,
    required this.carat,
    required this.condition,
    required this.isRare
  });

  String display() {
    return '$name ($brand, $material, $carat carat) - Value: \$${value.toStringAsFixed(2)}, Condition: $condition, Rare: $isRare';
  }

  factory Jewelry.fromJson(Map<String, dynamic> json) {
    return Jewelry(
      name: json['name'] as String? ?? 'Unknown',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      brand: json['brand'] as String? ?? 'Unknown',
      material: json['material'] as String? ?? 'Unknown',
      carat: (json['carat'] as num?)?.toDouble() ?? 0.0,
      condition: (json['condition'] as num?)?.toDouble() ?? 100.0,
      isRare: json['isRare'] as bool? ?? false,
    );
  }

  void degradeCondition(double percentage) {
    condition -= percentage;
    if (condition < 0) condition = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'brand': brand,
      'material': material,
      'carat': carat,
      'condition': condition,
      'isRare': isRare,
    };
  }
}