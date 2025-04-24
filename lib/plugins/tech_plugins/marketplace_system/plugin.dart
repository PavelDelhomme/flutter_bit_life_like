import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/plugins/tech_plugins/marketplace_system/widgets/marketplace_screen.dart';
import 'package:flutter/material.dart';

class MarketplaceSystemPlugin extends GamePlugin {
  @override
  String get id => 'marketplace_system';

  @override
  String get name => 'Marketplace';

  @override
  IconData get icon => Icons.shopping_cart;

  @override
  void onRegister(GamePluginContext context) {}

  @override
  void onGameStart() {}

  @override
  void apply(GamePluginContext context) {}

  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [
      PluginMenuEntry(
        title: "Marketplace",
        icon: icon,
        onTap: () {
          Navigator.push(
            context.gameState.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => MarketplaceScreen(
              title: "Marché", items: context.mainCharacter.marketplaceItems, onPurchase: (_) {}),
            ),
          );
        },
      ),
    ];
  }
}