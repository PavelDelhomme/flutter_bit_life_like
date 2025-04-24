class GameEvent {
  final String type;
  final String description;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  GameEvent({
    required this.type,
    required this.description,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory GameEvent.global(String description, {String type = "global", Map<String, dynamic> payload = const {}}) {
    return GameEvent(
      type: type,
      description: description,
      payload: payload,
    );
  }
  factory GameEvent.war(String country, String description) {
    return GameEvent(
      type: "war",
      description: description,
      payload: {'country': country},
    );
  }

}