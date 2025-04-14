import 'package:bitlife_like/models/inventory_item.dart';

class CraftingComponent implements InventoryItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final double value;
  @override
  final String type; // 'component'

  CraftingComponent({
    required this.id,
    required this.name,
    required this.value,
    this.type = 'component',
  });

  @override
  Map<String, double> get skillEffects => {};

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'type': type,
    };
  }
}
