import 'package:flutter/material.dart';
import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:bitlife_like/plugins/book_system/screens/book_list_screen.dart'; // screen à créer
import '../../core/plugin/has_routes.dart';
import '../../core/services/game_state_service.dart';

class BookSystemPlugin extends GamePlugin implements HasRoutes {
  @override
  void apply(GamePluginContext context) {}

  @override
  String get id => "book_system";

  @override
  String get name => "Système de livres";

  @override
  void onRegister() {}

  @override
  void onGameStart() {}

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      "/books": (context) => BookListScreen(), // screen à créer
    };
  }

  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [
      PluginMenuEntry(
        title: "Livres",
        icon: Icons.menu_book,
        onTap: () {
          //Navigator.pushNamed(context.gameState.navigatorKey.currentContext!, "/books");
          Navigator.pushNamed(
            GameStateService.instance.navigatorKey.currentContext!,
            "/books",
          );
        },
      )
    ];
  }
}
