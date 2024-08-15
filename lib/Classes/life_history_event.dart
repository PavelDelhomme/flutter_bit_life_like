class LifeHistoryEvent {
  final String description;
  final DateTime timestamp;

  LifeHistoryEvent({required this.description, required this.timestamp});

  // Convertir en JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LifeHistoryEvent.fromJson(Map<String, dynamic> json) {
    return LifeHistoryEvent(
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
