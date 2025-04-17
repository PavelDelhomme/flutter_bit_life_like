import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:flutter/material.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/game_plugin.dart';

class MenuBuilder {
  final List<GamePlugin> plugins;
  final GamePluginContext context;

  MenuBuilder({
    required this.plugins,
    required this.context,
  });

  List buildMainDrawerEntries() {
    return plugins
        .expand((plugin) => plugin.buildDrawerEntries(context))
        .toList();
  }

  List buildBottomItems() {
    return plugins
        .expand((plugin) => plugin.buildBottomNavigationItems(context))
        .toList();
  }
}