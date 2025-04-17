abstract class PluginBase {
  String get id;
  String get name;

  void onRegister();
  void onGameStart();
}