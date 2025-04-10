import '../../models/education/education.dart';
import '../../models/person/character.dart';

class EducationService {
  final List<Course> availableCourses;

  EducationService(this.availableCourses);

  void enrollCourse(Character character, String courseId) {
    final course = availableCourses.firstWhere((c) => c.id == courseId);
    if (course.requiredSkills.every((skillId, level) =>
    character.skills[skillId]?.currentLevel ?? 0 >= level)) {
      character.enrolledCourses.add(course);
      character.addLifeEvent("Inscription au cours: ${course.name}");
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