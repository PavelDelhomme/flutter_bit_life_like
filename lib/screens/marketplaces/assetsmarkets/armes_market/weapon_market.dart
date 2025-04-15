import 'package:bitlife_like/models/marketplace.dart';
import 'package:flutter/material.dart';
import '../../marketplace_screen.dart';

class WeaponsMarketScreen extends StatelessWidget {
  const WeaponsMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketplaceScreen(
      title: 'Marché d\'Armes',
      items: _generateWeapons(),
      onPurchase: (item) => _handleWeaponPurchase(item),
    );
  }

  void _handleWeaponPurchase(MarketplaceItem item) {
    // Ajouter ce que l'on veut faire quand on achète un weapon
    print("Acheté un weapon : ${item.name}");
  }

  List<MarketplaceItem> _generateWeapons() {
    return [
      MarketplaceItem(
        id: 'weapon_1',
        name: 'Pistolet de base',
        category: MarketplaceCategory.weapons,
        price: 500,
        requiredSkills: {'firearms': 2},
        expirationDate: DateTime.now().add(Duration(days: 30)),
      ),
      MarketplaceItem(
        id: 'weapon_2',
        name: 'Fusil d\'assaut',
        category: MarketplaceCategory.weapons,
        price: 2500,
        requiredSkills: {'firearms': 5},
        expirationDate: DateTime.now().add(Duration(days: 30)),
      ),
    ];
  }
}
