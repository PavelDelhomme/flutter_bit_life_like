import '../models/person/character.dart';
import '../models/asset/book.dart';

class BookManager {
  static void readBook(Character character, Book book) {
    if ((character.skillLevels['literacy'] ?? 0) >= book.comprehensionRequired) {
      book.skillEffects.forEach((skillId, exp) {
        final skill = character.skills[skillId];
        if (skill != null) {
          final multiplier = _getComprehensionMultiplier(character, skillId);
          skill.addExperience(exp * multiplier);
        }
      });
    }
  }

  static double _getComprehensionMultiplier(Character character, String skillId) {
    final base = character.skills[skillId]?.currentLevel ?? 0;
    return 1.0 + (base * 0.05);
  }
}
