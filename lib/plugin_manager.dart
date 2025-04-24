import 'package:flutter/material.dart';

import 'core/plugin/game_plugin.dart';
import 'core/plugin/game_plugin_context.dart';
import 'core/plugin/plugin_menu_entry.dart';
import 'core/services/game_state_service.dart';
import 'core/plugin/has_routes.dart';
import 'package:bitlife_like/plugins/book_system/plugin.dart';

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

  final List<GamePlugin> _availablePlugins = [
    BookSystemPlugin(),
    // Ajoute ici tous les autres plugins
  ];

  final List<GamePlugin> _activePlugins = [];

  void registerAll() {
    _activePlugins.clear();
    for (final plugin in _availablePlugins) {
      if (_shouldLoadPlugin(plugin)) {
        _activePlugins.add(plugin);
        plugin.onRegister();
      }
    }
  }

  Map<String, WidgetBuilder> getAllRoutes() {
    final Map<String, WidgetBuilder> routes = {};
    for (final plugin in _activePlugins) {
      if (plugin is HasRoutes) {
        routes.addAll((plugin as HasRoutes).getRoutes());
      }
    }
    return routes;
  }


  bool _shouldLoadPlugin(GamePlugin plugin) {
    return _currentCharacterPluginIds.contains(plugin.id);
  }

  Set<String> get _currentCharacterPluginIds =>
      GameStateService.instance.character.activePluginIds.toSet();

  void setPluginActive(GamePlugin plugin, bool activate) {
    final char = GameStateService.instance.character;

    if (activate) {
      if (!_activePlugins.any((p) => p.id == plugin.id)) {
        _activePlugins.add(plugin);
        plugin.onRegister();
      }
      if (!char.activePluginIds.contains(plugin.id)) {
        char.activePluginIds.add(plugin.id);
      }
    } else {
      _activePlugins.removeWhere((p) => p.id == plugin.id);
      char.activePluginIds.remove(plugin.id);
    }

    char.save();
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

    return _activePlugins
        .expand((plugin) => plugin.buildDrawerEntries(pluginContext))
        .toList();
  }

  List<GamePlugin> get availablePlugins => _availablePlugins;
  List<GamePlugin> get plugins => _activePlugins;

}