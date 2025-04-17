import 'package:bitlife_like/core/plugin/game_plugin_context.dart';
import 'package:bitlife_like/core/system/plugin_base.dart';

abstract class GamePlugin extends PluginBase {
  void apply(GamePluginContext context);
}