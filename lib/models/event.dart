class Event {
  final int age;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? effectOnStats;

  Event({
    required this.age,
    required this.description,
    required this.timestamp,
    this.effectOnStats,
  });
}