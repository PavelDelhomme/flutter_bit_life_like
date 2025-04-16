import '../../../core/shared/inventory_item.dart';

abstract class CraftableItem extends InventoryItem {
  List<String> get requiredComponentsIds;
}
