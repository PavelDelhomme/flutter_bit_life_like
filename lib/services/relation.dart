import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/person.dart';

import '../Classes/relationship.dart';


class RelationService {
  final Random _random = Random();

  void generateRandomEvent(Person person) {
    if (_random.nextDouble() > 0.5) {
      Person newFriend = PersonService().getRandomCharacter();
      person.friends.add(newFriend);
      print("${person.name} became friends with ${newFriend.name}");
      person.interactWith(newFriend, InteractionType.Positive);
    } else {
      if (person.friends.isNotEmpty) {
        Person friend = person.friends[_random.nextInt(person.friends.length)];
        print("${person.name} had a misunderstanding with ${friend.name}");
        person.interactWith(friend, InteractionType.Negative);
      }
    }
  }

  double calculateRelationshipQuality(Person person, Person other) {
    if (person.relationships.containsKey(other)) {
      return person.relationships[other]!.quality;
    }
    return 50.0; // Valeur par défaut si la relation n'est pas définie
  }

  void celebrateEvent(Person person, Person other) {
    person.interactWith(other, InteractionType.SpecialEvent);
  }
}