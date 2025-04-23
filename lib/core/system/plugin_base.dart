import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:flutter/material.dart';
import '../../core/plugin/game_plugin_context.dart';

abstract class PluginBase {
  /// Nom du plugin
  String get name;
  String get id;
  /// Icône (optionnelle) à afficher dans les menus
  IconData get icon;

  /// Appelé au démarrage du jeu
  void onRegister(GamePluginContext context);
  void onGameStart();

  /// Appelé à chaque changement d’année
  void onYearPassed(int year) {}

  /// Menus personnalisés dans le Drawer
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) => [];

  /// Routes (MaterialApp.routes)
  Map<String, WidgetBuilder> get routes => {};
}
