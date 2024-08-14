import 'dart:math';

import '../../Classes/event.dart';
import '../../Classes/person.dart';

class EventService {
  final List<Event> events;

  EventService({required this.events});

  Event? generateRandomEvent(Person person) {
    final random = Random();
    if (random.nextDouble() < 0.3) { // Par exemple, 30% de chances qu'un événement survienne
      Event event = events[random.nextInt(events.length)];
      if (random.nextDouble() <= event.probability) {
        return event;
      }
    }
    return null;
  }
}
