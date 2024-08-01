
import '../../Classes/person.dart';
import 'bank_account.dart';

class FinancialService {
  void handleDefault(Person person) {
    double debtAmont = person.bankAccounts.fold(0.0, (sum, account) => sum + account.totalDebt());

    for (var account in person.bankAccounts) {
      if (account.balance >= debtAmont) {
        account.withdraw(debtAmont);
        print("Debt of \$${debtAmont} recovered from account ${account.accountNumber}");
        return;
      }
    }

    // Si les comptes ne suffisent pas, saisir les biens
    seizeAssets(person, debtAmont);
  }

  void seizeAssets(Person person, double debtAmont) {
    // Logique poue saisir les bien ici a voir après
    print("Seizing assets to recover \$${debtAmont}");
  }

  void investInStock(BankAccount account, double amount) {
    if (account.balance >= amount) {
      // Logic to handle stock purchase
      print('Invested $amount in stocks.');
    } else {
      print('Insufficient funds to invest in stocks.');
    }
  }

  void investInCrypto(BankAccount account, double amount) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      // Logic to handle crypto purchase
      print("Invested $amount in crypto");
    } else {
      print("Insufficient funds to invest in crypto.");
    }
  }

  void buyBonds(BankAccount account, double amount) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      // Logicto handle bond purchase
      print("Bought bonds for $amount.");
    } else {
      print("Insufficient funds to buy bonds.");
    }
  }

  void applyLoan(BankAccount account, double amount) {
    account.applyLoan(amount);
    // Logic for demande de pret terms et repayment
    print("Pret d'un montant de ${amount} approuvé.");
  }
}