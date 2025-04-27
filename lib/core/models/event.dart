import 'dart:math';

class Event {
  final int age;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic> effects;
  final String? location;
  final List<String> involvedCharacters;

  Event({
    required this.age,
    required this.description,
    required this.timestamp,
    this.effects = const {},
    this.location,
    this.involvedCharacters = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'effects': effects,
      'location': location,
      'involvedCharacters': involvedCharacters,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      age: json['age'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      effects: Map<String, dynamic>.from(json['effects']),
      location: json['location'],
      involvedCharacters: List<String>.from(json['involvedCharacters']),
    );
  }
}


class WorldEvent {
  final String id;
  final String name;
  final String description;
  final String type;
  final double chance;
  final Map<String, dynamic> effects;

  WorldEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.chance,
    required this.effects,
  });

  bool shouldTrigger() {
    return Random().nextDouble() < chance;
  }

  factory WorldEvent.fromJson(Map<String, dynamic> json) {
    return WorldEvent(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      chance: (json['chance'] as num).toDouble(),
      effects: Map<String, dynamic>.from(json['effects']),
    );
  }
}