import 'dart:math';

import '../../Classes/person.dart';
import '../bank/bank_account.dart';

class DecisionService {
  void makeDecision(Person person, String decision) {
    switch (decision) {
      case 'start_business':
        BankAccount primaryAccount = person.bankAccounts.first;
        switch (decision) {
          case 'start_business':
            if (primaryAccount.balance >= 10000) {
              primaryAccount.withdraw(10000);
              print('${person.name} started a business!');
            } else {
              print('Not enough funds to start a business...');
              print('Not enough funds to start a business...');
              print('Would you like to apply for a bank loan?');
              print('Would you like to raise funds?');
            }
            break;
          case 'commit_crime':
          // Logique pour commettre un crime
            bool caught = Random().nextBool();
            if (caught) {
              primaryAccount.withdraw(5000);
              // Implémenter la logique pour se défendre devant la justice
              print('${person.name} got caught committing a crime.');
            } else {
              // Si non pris, gérer les montants en fonction du type de crime
              print('${person.name} successfully committed a crime.');
            }
            break;

        }
    }
  }
}
