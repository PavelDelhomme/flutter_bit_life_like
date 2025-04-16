

import 'package:bitlife_like/plugins/plugins/plugin_context.dart';
import 'package:bitlife_like/plugins/plugins_models.dart';

class PluginManager {
  final Map<String, GamePlugin> _plugins = {};
  final Set<String> _activePluginIds = {};

  void registerPlugin(GamePlugin plugin) {
    _plugins[plugin.id] = plugin;
  }

  void enablePlugin(String id, GamePluginContext context) {
    if (_plugins.containsKey(id)) {
      _plugins[id]!.onEnable(context);
      _activePluginIds.add(id);
    }
  }

  void disablePlugin(String id, GamePluginContext context) {
    if (_plugins.containsKey(id)) {
      _plugins[id]!.onDisable(context);
      _activePluginIds.remove(id);
    };
  }

  List<GamePlugin> get activePlugins => _activePluginIds.map((id) => _plugins[id]!).toList();

  List<GamePlugin> get allPlugins => _plugins.values.toList();
}