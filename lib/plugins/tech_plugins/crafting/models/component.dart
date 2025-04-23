
import '../../../../core/models/asset.dart';
import '../../../../core/shared/inventory_item.dart';

class Component implements InventoryItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final double value;

  Component({
    required this.id,
    required this.name,
    required this.value,
  });

  @override
  AssetType get type => AssetType.component;

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
