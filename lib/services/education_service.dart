
import 'dart:convert';
import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/education.dart';
import 'package:bit_life_like/services/pnj_service.dart';
import 'package:flutter/services.dart';

class EducationService {
  final PnjService pnjService = PnjService();

  void enrollInEducation(Person person, EducationLevel educationLevel) {
    person.currentEducation = educationLevel;
    educationLevel.classmates = pnjService.generateClassmates(person.country, Random().nextInt(20) + 5);
    person.incrementIntelligence(0.01); // Augmente très lentement l'intelligence lors de l'inscription
  }

  Future<List<EducationLevel>> loadEducationLevels() async {
    try {
      String data = await rootBundle.loadString('assets/educations.json');
      Map<String, dynamic> jsonResult = jsonDecode(data);

      List<EducationLevel> educationLevels = [];
      jsonResult['educations'].forEach((level, schools) {
        for (var school in schools) {
          educationLevels.add(EducationLevel.fromJson(school));
        }
      });
      return educationLevels;
    } catch (e) {
      print("Error loading education levels: $e");
      rethrow;
    }
  }

}