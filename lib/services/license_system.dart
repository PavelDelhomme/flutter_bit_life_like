import 'dart:math';

import '../models/legal.dart';
import '../models/person/character.dart';

class LicenseSystem {
  static final Map<String, Map<String, double>> _licenseRequirements = {
    'driver': {'driving': 0.7, 'legal': 0.5},
    'pilot': {'piloting': 0.9, 'physics': 0.8},
    'firearm': {'combat': 0.6, 'legal': 0.7},
  };

  static bool checkLicense(Character character, String licenseType) {
    return _licenseRequirements[licenseType]!.entries.every((req) {
      final skill = character.skills[req.key];
      return (skill?.currentLevel ?? 0) >= req.value;
    });
  }

  static void attemptIllegalAction(Character character, String actionType) {
    final detectionChance = _calculateDetectionRisk(character, actionType);
    if (Random().nextDouble() < detectionChance) {
      character.legalSystem?.processCrime(CrimeType.illegalActivity);
    }
  }

  static double _calculateDetectionRisk(Character character, String actionType) {
    return 0.3 - (character.skills['stealth']?.currentLevel ?? 0 * 0.01);
  }
}
