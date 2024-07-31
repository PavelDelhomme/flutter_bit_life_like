import 'dart:math';

import '../Classes/person.dart';

class EventService {
  void triggerRandomEvent(Person person) {
    int eventIndex = Random().nextInt(3);
    switch (eventIndex) {
      case 0:
        person.bankAccount += 1000;
        print('${person.name} found 1000\$^ !');
        break;
      case 1:
        person.bankAccount -= 500;
        print('${person.name} lost 500\$ !');
        break;
      case 2:
        // Other case ?? for random event to create
        break;
    }
  }
}