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
