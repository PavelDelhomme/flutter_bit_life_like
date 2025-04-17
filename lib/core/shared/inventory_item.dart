import 'package:bitlife_like/core/models/asset.dart';

abstract class InventoryItem {
  String get id;
  String get name;
  double get value;
  AssetType get type;

  Map<String, double> get skillEffects;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'type': type.toString(),
    };
  }
}
