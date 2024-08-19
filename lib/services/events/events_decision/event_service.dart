import 'dart:math';
import 'package:bit_life_like/Classes/event.dart';
import 'package:bit_life_like/Classes/person.dart';
import '../../../Classes/life_history_event.dart';

class EventService {
  final List<Event> events;

  EventService({required this.events});

  Event? generateRandomEvent(Person person) {
    final random = Random();

    if (random.nextDouble() < 0.3) {
      List<Event> applicableEvents = events.where((event) => _isEventApplicable(event, person)).toList();

      if (applicableEvents.isNotEmpty) {
        Event event = applicableEvents[random.nextInt(applicableEvents.length)];
        if (random.nextDouble() <= event.probability) {
          return event;
        }
      }
    }
    return null;
  }

  bool _isEventApplicable(Event event, Person person) {
    if (event.name == "Vehicle Accident" && person.getAllVehicles().isEmpty) {
      return false;
    }
    if (event.name == "Business Inspection" && person.businesses.isEmpty) {
      return false;
    }
    return true;
  }

  void triggerEvent(Person person, Event event) {
    event.effects.forEach((key, value) {
      switch (key) {
        case 'happiness':
          person.happiness += value;
          break;
        case 'wealth':
          person.bankAccounts.first.deposit(value);
          break;
        case 'intelligence':
          person.intelligence += value;
          break;
      }
    });

    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "Event: ${event.name} - ${event.description}",
      timestamp: DateTime.now(),
      ageAtEvent: person.age,
      personId: person.id
    ));
  }
}
