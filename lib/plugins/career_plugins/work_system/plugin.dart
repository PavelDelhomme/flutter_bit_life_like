import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/core/ui/main_game_screen.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/screens/job_search_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/plugin/activity_provider.dart';
import '../../../core/services/game_state_service.dart';
import '../entreprise/screens/entrepreneur_screen.dart';

class WorkSystemPlugin extends GamePlugin implements ActivityProvider {
  @override
  String get id => 'work_system_plugin';

  @override
  String get name => 'Work System';

  @override
  IconData get icon => Icons.work;

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
        title: "Chercher un emploi",
        icon: Icons.search,
        onTap: () {
          Navigator.push(
            GameStateService.instance.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => JobSearchScreen()),
          );
        },
      ),
      PluginMenuEntry(
        title: "Créer une entreprise",
        icon: Icons.business,
        onTap: () {
          Navigator.push(
            GameStateService.instance.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => EntrepreneurScreen(character: context.mainCharacter)),
          );
        },
      ),
    ];
  }


  @override
  List<ActivityEntry> getActivities() {
    return [
      ActivityEntry(
        title: "Chercher un emploi",
        icon: Icons.search,
        onTap: () {
          Navigator.push(
            GameStateService.instance.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const JobSearchScreen()),
          );
        },
      ),
    ];
  }
}