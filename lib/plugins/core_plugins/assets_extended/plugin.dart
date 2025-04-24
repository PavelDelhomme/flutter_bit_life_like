import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/core/ui/main_game_screen.dart';
import 'package:flutter/material.dart';

class AssetsExtendedPlugin extends GamePlugin {
  @override
  String get id => 'assets_extended';

  @override
  String get name => 'Assets extended';

  @override
  IconData get icon => Icons.access_alarms_rounded;

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
          title: "Assets extended",
          icon: icon,
          onTap: () {
            Navigator.push(
                context.gameState.navigatorKey.currentContext!,
                //MaterialPageRoute(builder: (_) => ActivityScreen(
                //
                //))
                MaterialPageRoute(builder: (_) => MainGameScreen())
            );
          }
      )
    ];
  }
}