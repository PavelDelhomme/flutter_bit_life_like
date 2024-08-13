import 'package:bit_life_like/Classes/objects/collectible_item.dart';

import '../../services/bank/bank_account.dart';
class Electronic implements CollectibleItem {
  String id;
  String type; // Par exemple : smartphone, laptop, server,...
  String brand;
  String model;
  double value;
  bool supportsApplications; // Indique si l'appareil peut exécuter des applications

  Electronic({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.value,
    this.supportsApplications = false,
  });

  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      value: json['price'],
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
    // TODO: implement display
    throw UnimplementedError();
  }

  @override
  // TODO: implement epoch
  String get epoch => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement rarity
  String get rarity => throw UnimplementedError();
}
