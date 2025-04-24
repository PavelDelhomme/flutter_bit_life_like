import 'dart:math';

import '../../../../core/models/activity.dart';
import '../../../../core/models/character.dart';

class ActivityManager {
  static Map<ActivityType, ActivityOutcome> performActivity(Character character, Activity activity) {
    final random = Random();
    final outcome = ActivityOutcome();

    // Vérification des prérequis
    if (!_meetsRequirements(character, activity)) {
      outcome.success = false;
      outcome.effects['stress'] = 15.0;
      return { activity.type: outcome }; // ✅ return la MAP ici
    }

    // Calcul du succès
    final successRate = _calculateSuccessRate(character, activity);
    outcome.success = random.nextDouble() < successRate;

    // Application des effets
    if (outcome.success) {
      activity.skillGains.forEach((skillId, exp) {
        character.improveSkill(skillId, exp * _getSkillMultiplier(character, skillId));
      });
    } else {
      outcome.effects['stress'] = 10.0;
    }

    return { activity.type: outcome }; // ✅ return une map ActivityType -> Outcome
  }


  static bool _meetsRequirements(Character character, Activity activity) {
    return activity.skillRequirements.entries.every((entry) {
      final skillId = entry.key;
      final requiredLevel = entry.value;
      final currentLevel = character.skills[skillId]?.currentLevel ?? 0;
      return currentLevel >= requiredLevel;
    });
  }


  static double _calculateSuccessRate(Character character, Activity activity) {
    double baseRate = activity.successRate;
    double skillBoost = activity.skillRequirements.entries.fold(0.0, (sum, entry) {
      final current = character.skills[entry.key]?.currentLevel ?? 0;
      return sum + (current >= entry.value ? 0.05 : -0.1); // bonus ou malus
    });

    return (baseRate + skillBoost).clamp(0.0, 1.0); // entre 0 et 1
  }


  static double _getSkillMultiplier(Character character, String skillId) {
    return 1.0 + (character.skills[skillId]?.currentLevel ?? 0) * 0.1;
  }
}
