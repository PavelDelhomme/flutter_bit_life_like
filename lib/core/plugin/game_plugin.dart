import 'package:flutter/material.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/core/system/plugin_base.dart';

abstract class GamePlugin extends PluginBase {
  void apply(GamePluginContext context);

  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [];
  }

  List<BottomNavigationBarItem> buildBottomBarItems(GamePluginContext context) {
    return [];
  }

  List<Widget> getWorkMenuEntries(BuildContext context) => [];
  List<Widget> getAssetsMenuEntries(BuildContext context) => [];
  List<Widget> getActivitiesMenuEntries(BuildContext context) => [];
  List<Widget> getRelationshipsMenuEntries(BuildContext context) => [];

}