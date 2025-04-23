import 'package:bitlife_like/plugins/core_plugins/activity_plugin/plugin.dart';
import 'package:bitlife_like/plugins/core_plugins/book_system/plugin.dart';
import 'package:bitlife_like/plugins/tech_plugins/crafting/plugin.dart';
import 'package:flutter/material.dart';

import 'core/plugin/game_plugin.dart';
import 'core/plugin/game_plugin_context.dart';
import 'core/plugin/plugin_menu_entry.dart';
import 'core/services/game_state_service.dart';
import 'core/plugin/has_routes.dart';

import 'package:bitlife_like/plugins/tech_plugins/marketplace_system/plugin.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/plugin.dart';
import 'package:bitlife_like/plugins/social_plugins/education/plugin.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/plugin.dart';
import 'package:bitlife_like/plugins/core_plugins/daily_life/plugin.dart';
import 'package:bitlife_like/plugins/core_plugins/logement/plugin.dart';
import 'package:bitlife_like/plugins/social_plugins/justice/plugin.dart';
import 'package:bitlife_like/plugins/social_plugins/vie_administrative/plugin.dart';
import 'package:bitlife_like/plugins/social_plugins/vie_familiale/plugin.dart';

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
      CraftingPlugin(),
      DailyLifePlugin(),
      LogementPlugin(),
      WorkSystemPlugin(),
      AssetsExtendedPlugin(),
      ActivityPlugin(),
      EducationPlugin(),
      JusticePlugin(),
      VieAdministrativePlugin(),
      VieFamilialePlugin(),
      MarketplaceSystemPlugin(),
    ]);

    final context = GamePluginContext(
      mainCharacter: GameStateService.instance.character,
      gameState: GameStateService.instance,
      eventService: GameStateService.instance.eventService,
    );

    for (var plugin in _plugins) {
      plugin.onRegister(context);
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

  List<Widget> getWorkMenuItems(BuildContext context) {
    return plugins.expand((plugin) => plugin.getWorkMenuEntries(context)).toList();
  }

}
