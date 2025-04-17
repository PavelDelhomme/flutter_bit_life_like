class GameEvent {
  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  GameEvent({
    required this.type,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}