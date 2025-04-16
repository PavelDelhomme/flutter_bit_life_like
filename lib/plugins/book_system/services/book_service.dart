import 'package:bitlife_like/plugins/book_system/models/book.dart';
import '../../../core/models/character.dart';

class BookService {
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
