import 'package:bitlife_like/models/activity.dart';
import 'package:bitlife_like/models/event/game_event.dart';
import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/plugins/plugins_models.dart';
import 'package:bitlife_like/plugins/plugins/plugin_context.dart';
import 'activities.dart';

class PolitiquePlugin extends GamePlugin {
  @override
  String get id => 'politique';

  @override
  String get name => 'Politique';

  @override
  String get description =>
      'Permet de faire carrière en politique, de gérer des campagnes électorales et d’influencer la société.';

  @override
  void onEnable(GamePluginContext context) {
    print('[PolitiquePlugin] Activé');
  }

  @override
  void onDisable(GamePluginContext context) {
    print('[PolitiquePlugin] Désactivé');
  }

  @override
  void onAgeUp(GamePluginContext context, Character character) {
    if (character.age >= 18) {
      context.unlockActivity(PoliticalCampaignActivity(character));
    }
  }

  @override
  List<Activity> getAvailableActivities(
      GamePluginContext context, Character character) {
    return character.age >= 18 ? [PoliticalCampaignActivity(character)] : [];
  }

  @override
  void onTick(GamePluginContext context) {
    if (context.random.nextDouble() < 0.03) {
      context.addGameEvent(GameEvent(
        id: 'election_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Élection locale',
        description: 'Des élections locales ont lieu cette année. Souhaitez-vous vous présenter ?',
        triggerYear: context.timeService.currentYear,
      ));
    }
  }
}
