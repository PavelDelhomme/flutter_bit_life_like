import 'package:bitlife_like/plugins/book_system/plugin.dart';
import 'package:flutter/material.dart';

import 'core/plugin/game_plugin.dart';
import 'core/plugin/game_plugin_context.dart';
import 'core/plugin/plugin_menu_entry.dart';
import 'core/services/game_state_service.dart';
import 'core/plugin/has_routes.dart'; // AJOUTE CETTE LIGNE

final List<GamePlugin> allPlugins = [
  // Ajouter tous les plugins manuellement ou en les auto-chargeant depuis le système de fichiers
  //MarketPlacePlugin(),
  //BookPlugin(),
  //EducationPlugin(),
  //WorkPlugin(),
];

class PluginManager {
  static final PluginManager _instance = PluginManager._internal();
  static PluginManager get instance => _instance;
  PluginManager._internal();

  final List<GamePlugin> _plugins = [];

  void registerAll() {
    _plugins.clear();
    _plugins.addAll([
      BookSystemPlugin(),
    ]);

    for (var plugin in _plugins) {
      plugin.onRegister();
    }
  }

  void startGamePlugins(GamePluginContext context) {
    for (var plugin in _plugins) {
      plugin.apply(context);
      plugin.onGameStart();
    }
  }

  List<PluginMenuEntry> getMainMenuItems(BuildContext context) {
    final gameState = GameStateService.instance;
    final pluginContext = GamePluginContext(
      mainCharacter: gameState.character,
      gameState: gameState,
      eventService: gameState.eventService,
    );

    return _plugins
        .expand((plugin) => plugin.buildDrawerEntries(pluginContext))
        .toList();
  }

  Map<String, WidgetBuilder> getAllRoutes() {
    final Map<String, WidgetBuilder> routes = {};
    for (final plugin in _plugins) {
      if (plugin is HasRoutes) {
        routes.addAll((plugin as HasRoutes).getRoutes());
      }
    }
    return routes;
  }


  List<GamePlugin> get plugins => _plugins;
}
