import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';

class EducationLevel {
  String name;
  String type;
  double cost;
  double stressLevel;
  int duration;
  Map<String, double> competences;
  List<Person> classmates;

  EducationLevel({
    required this.name,
    required this.type,
    required this.cost,
    required this.stressLevel,
    required this.duration,
    required this.competences,
    this.classmates = const [],
  });

  factory EducationLevel.fromJson(Map<String, dynamic> json) {
    return EducationLevel(
      name: json['ecole_name'],
      type: json['type'],
      cost: json['fraisAnnuel']?.toDouble() ?? 0.0,
      stressLevel: json['stressLevel']?.toDouble() ?? 0.0,
      duration: json['durée'],
      competences: Map<String, double>.from(json['competences'] ?? {}),
      classmates: (json['classmates'] as List<dynamic>?)
              ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ecole_name': name,
      'type': type,
      'fraisAnnuel': cost,
      'stressLevel': stressLevel,
      'durée': duration,
      'competences': competences,
      'classmates': classmates.map((e) => e.toJson()).toList(),
    };
  }
  bool checkIfGraduated(double academicPerformance, Person person) {
    // Ajout d'une composante probabiliste basée sur la performance
    double successChance = academicPerformance / 100.0 * (0.8 + Random().nextDouble() * 0.4); // Chance entre 80% et 120% de la performance
    return successChance >= 0.9 && academicPerformance >= 100;
  }


}
