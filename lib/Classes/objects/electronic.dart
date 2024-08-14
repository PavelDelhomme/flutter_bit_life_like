import 'package:bit_life_like/Classes/objects/collectible_item.dart';

class Electronic extends CollectibleItem {
  final String id;
  final String type; // Par exemple : smartphone, laptop, server,...
  final String brand;
  final String model;
  final double value;
  final bool supportsApplications;

  Electronic({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.value,
    this.supportsApplications = false,
  }) : super(
    name: '$brand $model',
    value: value,
    rarity: null,  // Si la rareté n'est pas applicable, mettez-le à null
    epoch: null,   // Si l'époque n'est pas applicable, mettez-le à null
  );

  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      value: (json['price'] as num?)?.toDouble() ?? 0.0,
      supportsApplications: json['supportsApplications'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'price': value,
      'supportsApplications': supportsApplications,
    };
  }

  @override
  String display() {
    return '$brand $model ($type) - Value: \$${value.toStringAsFixed(2)}';
  }

  @override
  String get epoch => 'Modern'; // Vous pouvez définir une valeur par défaut ou une logique spécifique

  @override
  String get name => '$brand $model';

  @override
  String get rarity => 'Common'; // Vous pouvez également définir une logique pour cela
}
