import 'package:bitlife_like/plugins/core_plugins/plugin_menu_item.dart';
import 'package:flutter/material.dart';

import '../../core/plugin/game_plugin_context.dart';

abstract class PluginBase {
  /// Nom du plugin
  String get name;

  /// Icône (optionnelle) à afficher dans les menus
  IconData get icon;

  /// Appelé au démarrage du jeu
  void onRegister(GamePluginContext context);

  /// Éléments du menu principal (Drawer)
  List<PluginMenuItem> getMainMenuItems(BuildContext context) => [];

  /// Routes personnalisées (utilisé dans MaterialApp routes)
  Map<String, WidgetBuilder> get routes => {};
}
