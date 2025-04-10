import '../models/person/character.dart';
import '../models/asset/book.dart';

class BookManager {
  static void readBook(Character character, Book book) {
    book.skillEffects.forEach((skillId, exp) {
      character.practiceSkill(skillId, exp);
    });
  }

  static double _getComprehensionMultiplier(Character character, String skillId) {
    final base = character.skills[skillId]?.currentLevel ?? 0;
    return 1.0 + (base * 0.05);
  }
}
