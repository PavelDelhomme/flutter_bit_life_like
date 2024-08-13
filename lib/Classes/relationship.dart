import 'package:bit_life_like/Classes/person.dart';

enum InteractionType {
  Positive,
  Neutral,
  Negative,
  SpecialEvent,
  MajorDecision,
}

class Relationship {
  Person other;
  double quality = 50.0; // Début de relation moyenne à 50%

  Relationship(this.other);

  void updateRelationship(InteractionType type, Person self, Person other) {
    double change = 0.0;
    switch (type) {
      case InteractionType.Positive:
        change = 5.0;
        break;
      case InteractionType.Neutral:
        change = 0.0;
        break;
      case InteractionType.Negative:
        change = -5.0;
        break;
      case InteractionType.SpecialEvent:
        change = 10.0;
        break;
      case InteractionType.MajorDecision:
        // Impact plus grand bassé sur les caractéristiques des personnages
        change = self.karma > 75 ? 10.0 : -10.0;
        break;
    }
    quality = (quality + change).clamp(0.0, 100.0);
    print("Relationship quality with ${other.name} is now $quality");
  }
}