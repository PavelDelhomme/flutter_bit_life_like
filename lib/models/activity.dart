import 'dart:math';

enum ActivityType {
  technical,
  social,
  physical,
  intellectual,
  creative,
  criminal,
  SpendTime,
  negocation,
  driving,
  piloting,
  hacking,
  law,
  research,
  medicine,
  education,
  cooking,
  farming,
  mining,
  construction,
  manufacturing,
  art,
  music,
  writing,
  sports,
  fitness,
  travel,
  exploration,
  socializing,
  dating,
  mentoring,
  volunteering,
  gardening,
  fishing,
  hunting,
  crafting,
  repair,
  finance,
  management,
  sales,
  marketing,
  customerService,
  publicSpeaking,
  negotiation,
  strategy,
  tactics,
  leadership,
  teamwork,
  espionage,
  security,
  investigation,
  puzzleSolving,
  storytelling,
  improvisation,
  performance
}


class Activity {
  final String id;
  final String name;
  final ActivityType type;
  final Map<String, double> skillRequirements; // Compétences nécessaires
  final Map<String, double> skillGains; // Gains d'expérience
  final double cost;
  final Duration duration;
  final double successRate; // 0.0 à 1.0
  final double risk; // Risque d'échec/conséquences

  Activity({
    required this.id,
    required this.name,
    required this.type,
    this.skillRequirements = const {},
    this.skillGains = const {},
    this.cost = 0.0,
    this.duration = const Duration(hours: 1),
    this.successRate = 0.7,
    this.risk = 0.2,
  });

  bool canPerform(Map<String, double> characterSkills) {
    return skillRequirements.every((skill, level) {
      return (characterSkills[skill] ?? 0) >= level;
    });
  }

  Map<String, double> performActivity(Map<String, double> characterSkills) {
    final random = Random();
    final success = random.nextDouble() < successRate;

    if (!success) {
      return { 'stress': risk * 10 };
    }

    return skillGains.map((key, value) {
      final gain = value * (1 + (characterSkills[key] ?? 0) / 10);
      return MapEntry(key, gain);
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'skillRequirements': skillRequirements,
      'skillGains': skillGains,
      'cost': cost,
      'duration': duration.inMilliseconds,
      'successRate': successRate,
      'risk': risk,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      type: ActivityType.values.firstWhere(
            (e) => e.toString() == json['type'],
        orElse: () => ActivityType.SpendTime,
      ),
      skillRequirements: json['skillRequirements'],
      skillGains: json['skillGains'],
      cost: json['cost'],
      duration: json['duration'],
      successRate: json['successRate'],
      risk: json['risk'],
    );
  }
}