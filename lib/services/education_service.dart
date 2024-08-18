
import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/education.dart';
import 'package:bit_life_like/services/pnj_service.dart';

class EducationService {
  final PnjService pnjService = PnjService();
  
  void enrollInEducation(Person person, EducationLevel educationLevel) {
    person.currentEducation = educationLevel;
    educationLevel.classmates = pnjService.generateClassmates(person.country, Random().nextInt(20) + 5);
  }

  List<EducationLevel> loadEducationLevels() {
    return [
      EducationLevel(name: 'High School', type: 'General', cost: 5000, stressLevel: 0.2, duration: 4, competences: {'Math': 0.8, 'Science': 0.7}),
      EducationLevel(name: 'University', type: 'STEM', cost: 15000, stressLevel: 0.4, duration: 3, competences: {'Engineering': 0.9, 'Physics': 0.8}),
    ];
  }
}