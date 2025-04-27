import 'package:bitlife_like/core/plugin/activity_provider.dart';
import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/core/ui/main_game_screen.dart';
import 'package:bitlife_like/plugins/core_plugins/activity_plugin/screens/general_activities_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/services/game_state_service.dart';

class ActivityPlugin extends GamePlugin implements ActivityProvider {
  @override
  String get id => 'activity';

  @override
  String get name => 'Activitiés Générales';

  @override
  IconData get icon => Icons.sports_esports;

  @override
  void onRegister(GamePluginContext context) {}

  @override
  void onGameStart() {}

  @override
  void apply(GamePluginContext context) {}

  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [];
  }

  @override
  List<ActivityEntry> getActivities() {
    return [
      ActivityEntry(
        title: "Activités Générales",
        icon: Icons.sports_esports,
        onTap: () {
          Navigator.push(
            GameStateService.instance.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const GeneralActivitiesScreen()),
          );
        },
      )
    ];
  }
}