import 'dart:math';
import 'package:bitlife_like/models/person/character.dart';

import 'marketplace.dart';

abstract class Market {
  final String location;
  final double priceMultiplier;
  final List<MarketplaceCategory> availableCategories;

  Market({
    required this.location,
    this.priceMultiplier = 1.0,
    required this.availableCategories,
  });

  List<MarketplaceItem> generateDailyItems(Character character) {
    return availableCategories.expand((category) {
      return List.generate(Random().nextInt(5) + 3, (_) => _generateItem(category, character));
    }).toList();
  }

  MarketplaceItem _generateItem(MarketplaceCategory category, Character character) {
    return MarketplaceItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      name: _generateItemName(category),
      category: category,
      price: Random().nextDouble() * 1000 * priceMultiplier,
      requiredSkills: _getRequiredSkillsForCategory(category),
      skillEffects: _generateSkillEffects(category),
      expirationDate: DateTime.now().add(Duration(days: 30)),
    );
  }

  Map<String, double> _getRequiredSkillsForCategory(MarketplaceCategory category) {
    switch(category) {
      case MarketplaceCategory.vehicles: return {'driving': 2.0};
      case MarketplaceCategory.books: return {'literacy': 3.0};
      default: return {};
    }
  }

  Map<String, double> _generateSkillEffects(MarketplaceCategory category) {
    switch(category) {
      case MarketplaceCategory.vehicles: return {'driving': 5.0};
      case MarketplaceCategory.books: return {'intelligence': 3.0};
      default: return {};
    }
  }

  String _generateItemName(MarketplaceCategory category) {
    switch(category) {
      case MarketplaceCategory.vehicles: return 'Véhicule ${Random().nextInt(1000)}';
      case MarketplaceCategory.books: return 'Livre ${Random().nextInt(1000)}';
      default: return 'Item Générique';
    }
  }

  bool canPurchase(MarketplaceItem item, Character character) {
    return item.requiredSkills.entries.every((entry) {
      final skillId = entry.key;
      final requiredLevel = entry.value;
      return (character.skills[skillId]?.currentLevel ?? 0) >= requiredLevel;
    });
  }
}
