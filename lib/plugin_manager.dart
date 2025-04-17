import 'package:bitlife_like/plugins/book_system/plugin.dart';

import 'core/plugin/game_plugin.dart';
import 'core/plugin/game_plugin_context.dart';

final List<GamePlugin> allPlugins = [
  // Ajouter tous les plugins manuellement ou en les auto-chargeant depuis le système de fichiers
  //MarketPlacePlugin(),
  //BookPlugin(),
  //EducationPlugin(),
  //WorkPlugin(),
];

class PluginManager {
  static final PluginManager _instance = PluginManager._internal();
  factory PluginManager() => _instance;
  PluginManager._internal();

  final List<GamePlugin> _plugins = [];

  void registerAll() {
    _plugins.clear();
    _plugins.addAll([
      BookSystemPlugin(),
    ]);

    for (var plugin in _plugins) {
      plugin.onRegister();
    }
  }

  void startGamePlugins(GamePluginContext context) {
    for (var plugin in _plugins) {
      plugin.apply(context);
      plugin.onGameStart();
    }
  }

  List<GamePlugin> get plugins => _plugins;
}