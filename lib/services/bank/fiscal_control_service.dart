
import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';

import '../../Classes/life_history_event.dart';

class FiscalControlService {
  bool performFiscalControl(Person person) {
    bool foundFraud = _checkForFraud(person);

    if (foundFraud) {
      double fine = person.calculateAnnualIncome() * 0.3; // Amende de 30% des revenus annuels
      person.bankAccounts.first.withdraw(fine);
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "Fiscal control detected fraud. Fine applied: \$${fine.toStringAsFixed(2)}",
        timestamp: DateTime.now(),
      ));
    } else {
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "Fiscal control completed. No fraud detected.",
        timestamp: DateTime.now(),
      ));
    }

    return foundFraud; // Retournez le résultat de la vérification
  }

  bool _checkForFraud(Person person) {
    // Simulez la logique de détection de fraude
    bool hasOffshoreAccounts = person.offshoreAccounts.isNotEmpty;
    bool undeclaredIncome = person.calculateAnnualIncome() > 100000 && Random().nextBool(); // Probabilité aléatoire
    return hasOffshoreAccounts && undeclaredIncome;
  }
}
