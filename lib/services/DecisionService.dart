import 'dart:math';

import '../Classes/person.dart';

class DecisionService {
  void makeDecision(Person person, String decision) {
    switch (decision) {
      case 'start_business':
        if (person.bankAccount.balance >= 10000) {
          person.bankAccount.withdraw(10000);
          // Logique pour démarrer une entreprise
          print('${person.name} started a business!');
        } else {
          print('Not enough funds to start a business...');
          print('Would you like to apply for a bank loan?');
          print('Would you like to raise funds?');
        }
        break;
      case 'commit_crime':
      // Logique pour commettre un crime
        bool caught = Random().nextBool();
        if (caught) {
          person.bankAccount.withdraw(5000);
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
