class LifeHistoryEvent {
  final String description;
  final DateTime timestamp;
  final int ageAtEvent;
  final String personId; // Ajout de l'identifiant de la personne

  LifeHistoryEvent({
    required this.description,
    required this.timestamp,
    required this.ageAtEvent,
    required this.personId, // Initialisation de l'identifiant de la personne
  });

  // Convertir en JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'ageAtEvent': ageAtEvent,
      'personId': personId, // Inclure l'identifiant dans la sérialisation
    };
  }

  factory LifeHistoryEvent.fromJson(Map<String, dynamic> json) {
    return LifeHistoryEvent(
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      ageAtEvent: json['ageAtEvent'],
      personId: json['personId'], // Restaurer l'identifiant à partir du JSON
    );
  }
}
