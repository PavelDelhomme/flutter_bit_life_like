import 'package:bitlife_like/models/activity.dart';
import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/plugins/plugins/plugin_context.dart';

abstract class GamePlugin {
  String get id;
  String get name;
  String get description;

  void onEnable(GamePluginContext context);
  void onDisable(GamePluginContext context);
  void onAgeUp(GamePluginContext context, Character character);
  List<Activity> getAvailableActivities(GamePluginContext context, Character character);
  void onTick(GamePluginContext context);
}