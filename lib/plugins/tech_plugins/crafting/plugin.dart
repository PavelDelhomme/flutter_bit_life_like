import 'package:flutter/material.dart';
import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/plugins/tech_plugins/crafting/screens/crafting_screen.dart';
import '../../../core/plugin/has_routes.dart';
import '../../../core/services/game_state_service.dart';


class CraftingPlugin extends GamePlugin implements HasRoutes {
  @override
  String get id => 'crafting';

  @override
  String get name => 'Crafting';

  @override
  void onRegister() {}

  @override
  void onGameStart() {}

  @override
  void apply(GamePluginContext context) {}

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      "/crafting": (context) => CraftingScreen(), // screen à créer
    };
  }

  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [
      PluginMenuEntry(
        title: "Crafting",
        icon: Icons.build,
        onTap: () {
          Navigator.pushNamed(
            GameStateService.instance.navigatorKey.currentContext!,
            "/crafting",
          );
        },
      )
    ];
  }

}
