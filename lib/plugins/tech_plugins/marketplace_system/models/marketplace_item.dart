
import '../../../../core/models/character.dart';
import 'marketplace_enum.dart';

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
    return requiredSkills.entries.every((entry) { // Utiliser entries sur requiredSkills
      final skillId = entry.key;
      final requiredLevel = entry.value;
      return (character.skills[skillId]?.currentLevel ?? 0) >= requiredLevel;
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