import 'package:bitlife_like/core/plugin/plugin_menu_entry.dart';
import 'package:flutter/material.dart';
import '../../core/plugin/game_plugin_context.dart';

abstract class PluginBase {
  /// Nom du plugin
  String get name;
  String get id;

  /// Icône pour le menu (obligatoire)
  IconData get icon;

  /// Enregistrement (à l'initialisation du jeu)
  void onRegister(GamePluginContext context);

  /// Appelé au lancement du jeu
  void onGameStart();

  /// Appelé à chaque changement d’année
  void onYearPassed(int year) {}

  /// Menus personnalisés dans le Drawer
  List<PluginMenuEntry> buildDrawerEntries(GamePluginContext context) => [];

  /// Routes (MaterialApp.routes)
  Map<String, WidgetBuilder> get routes => {};
}
