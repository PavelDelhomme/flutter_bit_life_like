

import 'package:bitlife_like/core/plugin/game_plugin.dart';
import 'package:bitlife_like/core/plugin/game_plugin_context.dart';

class BookSystemPlugin extends GamePlugin {
  @override
  String get id => 'book_system';

  @override
  String get name => "Système de Lecture";

  @override
  void onRegister() {
    // Chargement des données init etc
  }

  @override
  void onGameStart() {
    // Actions a faire au début du jeu
  }

  @override
  void apply(GamePluginContext context) {
    // Injecter ici dans EventService et SKillmanager etc...
  }
}