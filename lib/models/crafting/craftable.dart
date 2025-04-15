import 'package:bitlife_like/models/inventory_item.dart';

abstract class CraftableItem extends InventoryItem {
  List<String> get requiredComponentsIds;
}
