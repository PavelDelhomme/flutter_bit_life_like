import 'package:flutter/material.dart';
import '../../core/plugin/game_plugin.dart';
import '../../core/plugin/game_plugin_context.dart';
import '../../core/plugin/plugin_menu_entry.dart';

class BookPlugin extends GamePlugin {
  @override
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) {
    return [
      PluginMenuEntry(
        title: 'Bibliothèque',
        icon: Icons.menu_book,
        onTap: () {
          Navigator.of(context.navigatorKey.currentContext!).push(
            MaterialPageRoute(builder: (_) => BookLibraryScreen()),
          );
        },
      )
    ];
  }
}
