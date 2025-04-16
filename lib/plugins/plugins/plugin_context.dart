import 'package:bitlife_like/models/activity.dart';
import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/services/activity_system.dart';
import 'package:bitlife_like/services/time_age_event/age_service.dart';
import 'package:bitlife_like/services/time_age_event/events/events_decision/event_service.dart';
import 'package:bitlife_like/services/time_age_event/time_service.dart';
import 'package:bitlife_like/utils/random_generator.dart';
import 'package:bitlife_like/models/event/game_event.dart';

class GamePluginContext {
  final Character character;
  final TimeService timeService;
  final EventService eventService;
  final AgeService ageService;
  final ActivityManager activityManager;
  final RandomGenerator random;

  GamePluginContext({
    required this.character,
    required this.timeService,
    required this.eventService,
    required this.activityManager,
    required this.ageService,
    required this.random,
  });

  /// Ajoute un événement au jeu
  void addGameEvent(GameEvent event) {
    eventService.addEvent(event);
  }

  /// Planifie une activité dans les activités du personnage
  void scheduleActivity(Activity activity) {
    character.scheduledActivities.add(activity);
  }

  /// Débloque une nouvelle activité pour le personnage
  void unlockActivity(Activity activity) {
    activityManager.unlockActivity(character.id, activity);
  }
  /// Utilitaire pour apprendre une compétence directement
  void gainSkill(String skillId, double xp) {
    character.improveSkill(skillId, xp);
  }

  /// Avance le temps (si autorisé)
  void advanceTime({int days = 1}) {
    timeService.advanceTime(days: days);
  }

  /// Exemple d’action d’âge
  Future<void> triggerAgeUp() async {
    await ageService.ageUp(character);
  }


}
