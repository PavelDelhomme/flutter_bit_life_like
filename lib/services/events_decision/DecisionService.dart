import 'dart:math';

import '../../Classes/person.dart';
import '../bank/bank_account.dart';

class DecisionService {
  void makeDecision(Person person, String decision) {
    BankAccount primaryAccount = person.bankAccounts.first;

    switch (decision) {
      case 'start_business':
        if (primaryAccount.balance >= 10000) {
          primaryAccount.withdraw(10000);
          print('${person.name} started a business!');
        } else {
          print('Not enough funds to start a business...');
          print('Would you like to apply for a bank loan?');
        }
        break;

      case 'commit_crime':
        bool caught = Random().nextBool();
        if (caught) {
          primaryAccount.withdraw(5000);
          print('${person.name} got caught committing a crime.');
          // Implémenter la logique pour se défendre devant la justice
        } else {
          print('${person.name} successfully committed a crime.');
          // Si non pris, gérer les montants en fonction du type de crime
        }
        break;

    // Ajouter d'autres décisions selon les besoins...
    }
  }
}

