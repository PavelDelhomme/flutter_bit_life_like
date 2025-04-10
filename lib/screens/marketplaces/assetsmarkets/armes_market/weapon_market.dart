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

  List<MarketItem> _generateWeapons() {
    return [
      MarketItem(
        name: 'Pistolet de base',
        price: 500,
        requiredSkills: {'firearms': 2},
      ),
      MarketItem(
        name: 'Fusil d\'assaut',
        price: 2500,
        requiredSkills: {'firearms': 5},
      ),
    ];
  }
}
