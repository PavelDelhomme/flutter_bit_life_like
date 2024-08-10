

import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class UnemploymentService {
  void applyForBenefits(Person person) {
    if (person.jobs.isEmpty && person.jobHistory.length >= 3) {
      double benefitAmount = person.jobHistory.fold(0.0, (sum, job) => sum + job.salary * 0.1); // 10% of last job's salary
      BankAccount? primaryAccount = person.bankAccounts.isNotEmpty ? person.bankAccounts.first : null;
      if (primaryAccount != null) {
        primaryAccount.deposit(benefitAmount);
        print("Unemployment benefits of \$${benefitAmount} have been credited.");
      } else {
        print("No bank account to deposit benefits.");
      }
    }
  }
}