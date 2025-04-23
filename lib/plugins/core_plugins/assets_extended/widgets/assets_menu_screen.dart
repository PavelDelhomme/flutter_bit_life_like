import 'package:flutter/material.dart';

import '../../../../core/models/asset.dart';
import '../../../../core/ui/base_menu_screen.dart';

class AssetsMenuScreen extends StatelessWidget {
  final List<Asset> assets;

  const AssetsMenuScreen({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return BaseMenuScreen(
      title: 'Gestion des Actifs',
      items: assets.map((asset) => ListTile(
        leading: Icon(_getIconForAssetType(asset.type)),
        title: Text(asset.name),
        subtitle: Text('Valeur: \$${asset.value.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToAssetDetail(context, asset),
      )).toList(),
    );
  }

  IconData _getIconForAssetType(AssetType type) {
    switch (type) {
      case AssetType.vehicle: return Icons.directions_car;
      case AssetType.realEstate: return Icons.house;
      case AssetType.jewelry: return Icons.diamond;
      default: return Icons.attach_money;
    }
  }

  void _navigateToAssetDetail(BuildContext context, Asset asset) {
    // Navigation vers le détail de l'actif
  }
}
