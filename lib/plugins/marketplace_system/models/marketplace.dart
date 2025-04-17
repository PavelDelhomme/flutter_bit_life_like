import 'dart:math';

import '../../../core/models/character.dart';
import '../../crafting/services/component_service.dart';
import 'marketplace_enum.dart';
import 'marketplace_item.dart';

class Marketplace {
  final String location;
  final List<MarketplaceCategory> availableCategories;
  // final Map<String, List<MarketplaceItem>> _marketCategories = {
  //   'vehicles': _generateVehicles(),
  //   'books': _generateBooks(),
  //   'weapons': _generateWeapons(),
  // };
  final double priceMultiplier;

  Marketplace({
    required this.location,
    required this.availableCategories,
    this.priceMultiplier = 1.0,
  });

  static List<MarketplaceItem> _generateVehicles() {
    return [
      MarketplaceItem(
        id: 'veh_1',
        name: 'Voiture',
        category: MarketplaceCategory.vehicles,
        price: 1000.0,
        requiredSkills: {'driving': 2.0},
        skillEffects: {'driving': 5.0},
        expirationDate: DateTime.now().add(Duration(days: 30)),
      ),
    ];
  }

  static List<MarketplaceItem> _generateBooks() {
    return [
      MarketplaceItem(
        id: 'bok_1',
        name: 'Book',
        category: MarketplaceCategory.books,
        price: 1000.0,
        requiredSkills: {'driving': 2.0},
        skillEffects: {'driving': 5.0},
        expirationDate: DateTime.now().add(Duration(days: 30)),
      ),
    ];
  }

  static List<MarketplaceItem> _generateWeapons() {
    return [
      MarketplaceItem(
        id: 'wea_1',
        name: 'Weapon',
        category: MarketplaceCategory.weapons,
        price: 1000.0,
        requiredSkills: {'driving': 2.0},
        skillEffects: {'driving': 5.0},
        expirationDate: DateTime.now().add(Duration(days: 30)),
      ),
    ];
  }

  static Future<List<MarketplaceItem>> _generateComponents() async {
    final components = await ComponentService.loadComponents();
    return components.map((c) {
      return MarketplaceItem(
        id: c.id,
        name: c.name,
        category: MarketplaceCategory.components,
        price: c.value,
        expirationDate: DateTime.now().add(Duration(days: 30)),
      );
    }).toList();
  }


  Future<List<MarketplaceItem>> generateDailyItems(Character character) async {
    List<MarketplaceItem> items = [];

    for (final category in availableCategories) {
      if (category == MarketplaceCategory.components) {
        final componentItems = await _generateComponents();
        items.addAll(componentItems);
      } else {
        final generated = List.generate(Random().nextInt(5) + 3, (_) => _generateItem(category, character));
        items.addAll(generated);
      }
    }

    return items;
  }


  static Map<String, double> _getRequiredSkillsForCategory(MarketplaceCategory category) {
    switch(category) {
      case MarketplaceCategory.vehicles: return {'driving': 2.0};
      case MarketplaceCategory.books: return {'literacy': 3.0};
      default: return {};
    }
  }


  static Map<String, double> _generateSkillEffects(MarketplaceCategory category) {
    switch(category) {
      case MarketplaceCategory.vehicles: return {'driving': 5.0};
      case MarketplaceCategory.books: return {'intelligence': 3.0};
      default: return {};
    }
  }

  MarketplaceItem _generateItem(MarketplaceCategory category, Character character) {
    final id = 'item_${DateTime.now().millisecondsSinceEpoch}';
    final name = _generateItemName(category);
    final price = Random().nextDouble() * 1000 * priceMultiplier;

    return MarketplaceItem(
      id: id,
      name: name,
      category: category,
      price: price,
      requiredSkills: _getRequiredSkillsForCategory(category),
      skillEffects: _generateSkillEffects(category),
      expirationDate: DateTime.now().add(Duration(days: 30)),
    );
  }

  String _generateItemName(MarketplaceCategory category) {
    switch(category) {
      case MarketplaceCategory.vehicles: return 'Véhicule ${Random().nextInt(1000)}';
      case MarketplaceCategory.books: return 'Livre ${Random().nextInt(1000)}';
      default: return 'Item Générique';
    }
  }
}