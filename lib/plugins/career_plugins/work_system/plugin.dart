import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/core/ui/main_game_screen.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/screen/job_market_screen.dart';
import 'package:flutter/material.dart';

class WorkSystemPlugin extends GamePlugin {
  @override
  String get id => 'work_system_plugin';

  @override
  String get name => 'Work System';

  @override
  IconData get icon => Icons.access_alarms_rounded;

  @override
  void onRegister(GamePluginContext context) {}

  @override
  void onGameStart() {}

  @override
  void apply(GamePluginContext context) {}

  @override
  List<Widget> getWorkMenuEntries(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.store),
        title: const Text("Marché de l'emploi"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JobMarketScreen()),
          );
        },
      ),
    ];
  }


  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [
      PluginMenuEntry(
          title: "Work System",
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