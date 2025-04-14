import 'dart:convert';
import 'dart:io';

import 'package:bitlife_like/models/crafting/component.dart';
import 'package:bitlife_like/models/inventory_item.dart';
import 'package:bitlife_like/models/item_factory.dart';
import 'package:bitlife_like/models/marketplace.dart';

import '../models/person/character.dart';
import '../models/crafting/recipe.dart';

class CraftingService {
  late List<CraftingRecipe> _recipes;

  CraftingService() {
    _loadRecipes();
  }

  void _loadRecipes() {
    final file = File('assets/recipes.json');
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    _recipes = jsonData.map((e) => CraftingRecipe(
      id: e['id'],
      resultItemType: e['resultItemType'],
      requiredComponentIds: List<String>.from(e['requiredComponentIds']),
      quantities: Map<String, int>.from(e['quantities']),
    )).toList();
  }

  List<CraftingRecipe> getAvailableRecipes() => _recipes;

  bool canCraft(Character character, CraftingRecipe recipe) {
    final Map<String, int> invCounts = {};
    for (final item in character.inventory.whereType<CraftingComponent>()) {
      invCounts[item.id] = (invCounts[item.id] ?? 0) + 1;
    }

    for (final entry in recipe.quantities.entries) {
      if ((invCounts[entry.key] ?? 0) < entry.value) return false;
    }

    return true;
  }

  InventoryItem? craft(Character character, CraftingRecipe recipe) {
    if (!canCraft(character, recipe)) return null;

    // retirer les composants de l'inventaire
    for (final entry in recipe.quantities.entries) {
      int remaining = entry.value;
      character.inventory.removeWhere((item) {
        if (item is CraftingComponent && item.id == entry.key && remaining > 0) {
          remaining--;
          return true;
        }
        return false;
      });
    }

    final newItem = _createItem(recipe.resultItemType, character.id);
    character.addToInventory(newItem);
    return newItem;
  }

  InventoryItem _createItem(String type, String ownerId) {
    final marketplaceItem = MarketplaceItem(
      id: 'mk_${DateTime.now().millisecondsSinceEpoch}',
      name: "Objet Crafté ($type)",
      category: _mapTypeToCategory(type),
      price: 0,
      expirationDate: DateTime.now().add(Duration(days: 365)),
    );

    return ItemFactory.fromMarketplace(marketplaceItem, ownerId);
  }

  MarketplaceCategory _mapTypeToCategory(String type) {
    switch (type) {
      case 'weapon':
        return MarketplaceCategory.weapons;
      case 'vehicle':
        return MarketplaceCategory.vehicles;
      case 'electronic':
        return MarketplaceCategory.electronics;
      case 'instrument':
        return MarketplaceCategory.instruments;
      case 'realEstate':
        return MarketplaceCategory.realEstates;
      case 'jewelry':
        return MarketplaceCategory.jewelry;
      default:
        throw Exception("Type inconnu : $type");
    }
  }
}
