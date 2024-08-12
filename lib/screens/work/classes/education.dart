class EducationLevel {
  String name;
  String type;
  double cost;
  double stressLevel;
  int duration;
  Map<String, double> competences;

  EducationLevel({
    required this.name,
    required this.type,
    required this.cost,
    required this.stressLevel,
    required this.duration,
    required this.competences,
  });

  factory EducationLevel.fromJson(Map<String, dynamic> json) {
    return EducationLevel(
      name: json['ecole_name'],
      type: json['type'],
      cost: json['fraisAnnuel']?.toDouble() ?? 0.0,
      stressLevel: json['stressLevel']?.toDouble() ?? 0.0,
      duration: json['durée'],
      competences: Map<String, double>.from(json['competences'] ?? {}),
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
    };
  }
}
