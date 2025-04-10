import 'dart:math';

import '../models/activity.dart';
import '../models/person/character.dart';

class ActivityManager {
  static Map<ActivityType, ActivityOutcome> performActivity(Character character, Activity activity) {
    final random = Random();
    final outcome = ActivityOutcome();

    // Vérification des prérequis
    if (!_meetsRequirements(character, activity)) {
      outcome.success = false;
      outcome.effects['stress'] = 15.0;
      return outcome;
    }

    // Calcul du succès
    final successRate = _calculateSuccessRate(character, activity);
    outcome.success = random.nextDouble() < successRate;

    // Application des effets
    if (outcome.success) {
      activity.skillEffects.forEach((skillId, exp) {
        character.improveSkill(skillId, exp * _getSkillMultiplier(character, skillId));
      });
    } else {
      outcome.effects['stress'] = 10.0;
    }

    return outcome;
  }

  static double _getSkillMultiplier(Character character, String skillId) {
    return 1.0 + (character.skills[skillId]?.currentLevel ?? 0) * 0.1;
  }
}
