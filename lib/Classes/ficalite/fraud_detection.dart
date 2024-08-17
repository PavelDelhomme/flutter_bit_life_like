import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';

class FraudDetectionService {
  bool detectFraud(Person person) {
    bool hasOffshoreAccounts = person.offshoreAccounts.isNotEmpty;
    bool undeclaredIncome = person.calculateAnnualIncome() > 100000 && Random().nextBool();
    return hasOffshoreAccounts || undeclaredIncome;
  }
}
