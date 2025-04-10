import '../../models/education/education.dart';
import '../../models/person/character.dart';

class EducationService {
  final List<Course> availableCourses;

  EducationService(this.availableCourses);

  void enrollCourse(Character character, String courseId) {
    final course = availableCourses.firstWhere((c) => c.id == courseId);
    if (course.requiredSkills.entries.every((entry) { // Utiliser entries.every
      final skillId = entry.key;
      final requiredLevel = entry.value;
      return (character.skills[skillId]?.currentLevel ?? 0) >= requiredLevel;
    })) {
      character.enrolledCourses.add(course);
    }
  }

  void completeCourse(Character character, String courseId) {
    final course = character.enrolledCourses.firstWhere((c) => c.id == courseId);
    course.skillRewards.forEach((skillId, exp) {
      character.practiceSkill(skillId, exp);
    });
    character.completedCourses.add(courseId);
    character.enrolledCourses.removeWhere((c) => c.id == courseId);
  }
}