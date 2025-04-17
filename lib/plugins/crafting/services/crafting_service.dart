import 'dart:convert';
import 'dart:io';

import '../../../core/models/character.dart';
import '../../../core/shared/inventory_item.dart';
import '../../../core/shared/item_factory.dart';
import '../../marketplace_system/models/marketplace_enum.dart';
import '../../marketplace_system/models/marketplace_item.dart';
import '../models/component.dart';
import '../models/recipe.dart';

class CraftingService {
  late List<Recipe> _recipes;

  CraftingService() {
    _loadRecipes();
  }

  void _loadRecipes() {
    final file = File('assets/recipes.json');
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    _recipes = jsonData.map((e) => Recipe(
      id: e['id'],
      resultItemType: e['resultItemType'],
      requiredComponentIds: List<String>.from(e['requiredComponentIds']),
      quantities: Map<String, int>.from(e['quantities']),
      requiredSkills: Map<String, double>.from(e['requiredSkills'] ?? {}),
    )).toList();
  }

  List<Recipe> getAvailableRecipes() => _recipes;

  bool canCraft(Character character, Recipe recipe) {
    final Map<String, int> invCounts = {};
    for (final item in character.inventory.whereType<Component>()) {
      invCounts[item.id] = (invCounts[item.id] ?? 0) + 1;
    }

    for (final entry in recipe.quantities.entries) {
      if ((invCounts[entry.key] ?? 0) < entry.value) return false;
    }

    return true;
  }

  bool _hasRequiredSkills(Character c, Recipe r) {
    return r.requiredSkills.entries.every((entry) {
      final level = c.skills[entry.key]?.currentLevel ?? 0;
      return level >= entry.value;
    });
  }

  InventoryItem? craft(Character character, Recipe recipe) {
    if (!canCraft(character, recipe)) return null;

    // retirer les composants de l'inventaire
    for (final entry in recipe.quantities.entries) {
      int remaining = entry.value;
      character.inventory.removeWhere((item) {
        if (item is Component && item.id == entry.key && remaining > 0) {
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
      case 'weapon': return MarketplaceCategory.weapons;
      case 'vehicle': return MarketplaceCategory.vehicles;
      case 'electronic': return MarketplaceCategory.electronics;
      case 'instrument': return MarketplaceCategory.instruments;
      case 'realEstate': return MarketplaceCategory.realEstates;
      case 'jewelry': return MarketplaceCategory.jewelry;
      case 'component': return MarketplaceCategory.components;
      default:
        throw Exception("Type inconnu : $type");
    }
  }
}
