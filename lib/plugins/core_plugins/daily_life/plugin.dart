import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/core/ui/main_game_screen.dart';
import 'package:flutter/material.dart';

class DailyLifePlugin extends GamePlugin {
  @override
  String get id => 'daily_life_plugin';

  @override
  String get name => 'Daily Life Plugin';

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
          title: "Daily Life Plugin",
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