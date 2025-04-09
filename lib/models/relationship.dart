enum RelationshipType {
  parent,
  child,
  sibling,
  spouse,
  friend,
  colleague,
  boss,
  enemy,
  exSpouse,
  lover
}

enum RelationshipStatus {
  excellent,
  good,
  neutral,
  poor,
  hostile,
  estranged
}

class Relationship {
  final String id;
  final String characterId;
  final String targetId;
  RelationshipType type;
  RelationshipStatus status;
  double compatibilityScore; // 0.0 à 1.0
  double respectLevel; // 0.0 à 1.0
  double trustLevel; // 0.0 à 1.0
  int yearsKnown;
  bool isBlocked;
  List<String> sharedExperiences;
  List<String> sharedAssets; // IDs des biens partagés
  List<String> conflicts;
  
  Relationship({
    required this.id,
    required this.characterId,
    required this.targetId,
    required this.type,
    this.status = RelationshipStatus.neutral,
    this.compatibilityScore = 0.5,
    this.respectLevel = 0.5,
    this.trustLevel = 0.5,
    this.yearsKnown = 0,
    this.isBlocked = false,
    List<String>? sharedExperiences,
    List<String>? sharedAssets,
    List<String>? conflicts,
  }) : 
    sharedExperiences = sharedExperiences ?? [],
    sharedAssets = sharedAssets ?? [],
    conflicts = conflicts ?? [];
  
  void improve(double amount) {
    compatibilityScore = (compatibilityScore + amount).clamp(0.0, 1.0);
    _updateStatus();
  }
  
  void deteriorate(double amount) {
    compatibilityScore = (compatibilityScore - amount).clamp(0.0, 1.0);
    _updateStatus();
  }
  
  void _updateStatus() {
    if (compatibilityScore >= 0.8) {
      status = RelationshipStatus.excellent;
    } else if (compatibilityScore >= 0.6) {
      status = RelationshipStatus.good;
    } else if (compatibilityScore >= 0.4) {
      status = RelationshipStatus.neutral;
    } else if (compatibilityScore >= 0.2) {
      status = RelationshipStatus.poor;
    } else {
      status = RelationshipStatus.hostile;
    }
  }
  
  void addSharedExperience(String experience) {
    sharedExperiences.add(experience);
    // Une expérience partagée améliore légèrement la relation
    improve(0.02);
  }
  
  void addConflict(String conflict) {
    conflicts.add(conflict);
    // Un conflit détériore la relation
    deteriorate(0.05);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'targetId': targetId,
      'type': type.toString(),
      'status': status.toString(),
      'compatibilityScore': compatibilityScore,
      'respectLevel': respectLevel,
      'trustLevel': trustLevel,
      'yearsKnown': yearsKnown,
      'isBlocked': isBlocked,
      'sharedExperiences': sharedExperiences,
      'sharedAssets': sharedAssets,
      'conflicts': conflicts,
    };
  }
  
  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      characterId: json['characterId'],
      targetId: json['targetId'],
      type: RelationshipType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => RelationshipType.friend,
      ),
      status: RelationshipStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => RelationshipStatus.neutral,
      ),
      compatibilityScore: json['compatibilityScore'],
      respectLevel: json['respectLevel'],
      trustLevel: json['trustLevel'],
      yearsKnown: json['yearsKnown'],
      isBlocked: json['isBlocked'],
      sharedExperiences: List<String>.from(json['sharedExperiences']),
      sharedAssets: List<String>.from(json['sharedAssets']),
      conflicts: List<String>.from(json['conflicts']),
    );
  }
}
