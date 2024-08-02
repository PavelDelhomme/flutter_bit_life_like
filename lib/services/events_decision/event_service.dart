import 'dart:math';

import '../../Classes/person.dart';

class EventService {
  void triggerRandomEvent(Person person) {
    int eventIndex = Random().nextInt(3);
    switch (eventIndex) {
      case 0:
        if (person.bankAccounts.isNotEmpty) {
          person.bankAccounts.first.deposit(1000);
          print('${person.name} found \$1000!');
        }
        break;
      case 1:
        if (person.bankAccounts.isNotEmpty) {
          person.bankAccounts.first.withdraw(500);
          print('${person.name} lost \$500!');
        }
        break;
      case 2:
      // Other case for a random event
        break;
    }
  }
}
