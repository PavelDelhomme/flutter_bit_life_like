import 'dart:math';

import 'package:bitlife_like/models/person/character.dart';

enum MarketplaceCategory {
  realEstate,
  vehicles,
  jewelry,
  antiques,
  weapons,
  books,
  courses
}


class MarketplaceItem {
  final String id;
  final String name;
  final MarketplaceCategory category;
  final double price;
  final Map<String, double> requiredSkills; // Compétences nécessaires pour acheter
  final Map<String, double> skillEffects; // Effets sur les compétences
  final double rarity; // 0.0 à 1.0
  final DateTime expirationDate;

  MarketplaceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.requiredSkills = const {},
    this.skillEffects = const {},
    this.rarity = 0.5,
    required this.expirationDate,
  });

  bool canPurchase(Character character) {
    return character.skills.every((skill) {
      final requiredLevel = requiredSkills[skill.id] ?? 0;
      return skill.currentLevel >= requiredLevel;
    }) && character.money >= price;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toString(),
      'price': price,
      'requiredSkills': requiredSkills,
      'skillEffects': skillEffects,
      'rarity': rarity,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['id'],
      name: json['name'],
      category: MarketplaceCategory.values.firstWhere(
            (e) => e.toString() == json['category'],
        orElse: () => MarketplaceCategory.books,
      ),
      price: json['price'],
      requiredSkills: Map<String, double>.from(json['requiredSkills']),
      skillEffects: Map<String, double>.from(json['skillEffects']),
      rarity: json['rarity'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }
}

class Marketplace {
  final String location;
  final List<MarketplaceCategory> availableCategories;
  final Map<String, List<MarketplaceItem>> _marketCategories = {
    'vehicles': _generateVehicles(),
    'books': _generateBooks(),
    'weapons': _generateWeapons(),
  };
  final double priceMultiplier;

  Marketplace({
    required this.location,
    required this.availableCategories,
    this.priceMultiplier = 1.0,
  });


  List<MarketplaceItem> generateDailyItems(Character character) {
    return availableCategories.expand((category) {
      return List.generate(Random().nextInt(5) + 3, (_) => _generateItem(category, character));
    }).toList();
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