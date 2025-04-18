class GameEvent {
  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  GameEvent({
    required this.type,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory GameEvent.global(String description) {
    return GameEvent(
      type: "global",
      payload: {'description': description},
      timestamp: DateTime.now(),
    );
  }
  factory GameEvent.war(String country) {
    return GameEvent(
      type: "war",
      payload: {'country': country},
    );
  }

}