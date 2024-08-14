import 'dart:convert';

import 'package:flutter/services.dart';

import '../../Classes/person.dart';
import 'bank_account.dart';

class FinancialService {
  FinancialService._privateConstructor();

  static final FinancialService _instance =
      FinancialService._privateConstructor();
  static FinancialService get instance => _instance;

  
  static double _inflationRate = 0.02; // Par défaut 2% d'inflation annuelle
  
  static double get inflationRate => _inflationRate;

  static void updateInflationRate(double newRate) {
    _inflationRate = newRate;
  }

  static double applyInflation(double amount) {
    return amount * (1 + _inflationRate);
  }

  static double adjustCost(double baseCost) {
    return baseCost * (1 + _inflationRate);
  }

  static double adjustSalary(double baseSalary) {
    return baseSalary * (1 + _inflationRate);
  }

  static List<dynamic> bankData = [];

  static Future<List<dynamic>> loadBankData() async {
    final String response = await rootBundle.loadString('assets/banks.json');
    bankData = json.decode(response)['banks'];
    return bankData;
  }

  static double getInterestRate(String bankName, String accountType) {
    var foundBank = bankData.firstWhere((bank) => bank['name' == bankName],
        orElse: () => null);
    if (foundBank != null) {
      var foundAccount = foundBank['accounts'].firstWhere(
          (account) => account['type'] == accountType,
          orElse: () => null);
      return foundAccount != null ? foundAccount['interestRate'] : 0.0;
    }
    return 0.0;
  }

  void handleDefault(Person person) {
    double debtAmont = person.bankAccounts
        .fold(0.0, (sum, account) => sum + account.totalDebt());

    for (var account in person.bankAccounts) {
      if (account.balance >= debtAmont) {
        account.withdraw(debtAmont);
        print(
            "Debt of \$${debtAmont} recovered from account ${account.accountNumber}");
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

  bool investInStock(BankAccount account, double amount) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      print('Invested \$$amount in stocks.');
      return true;
    } else {
      print('Insufficient funds to invest in stocks.');
      return false;
    }
  }

  bool investInCrypto(BankAccount account, double amount) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      print("Invested $amount in crypto");
      return true;
    } else {
      print("Insufficient funds to invest in crypto.");
      return false;
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

  bool applyForLoan(BankAccount account, double amount, int years, double rate) {
    double monthlyIncome = account.annualIncome / 12;
    double monthlyRepayment = amount / (years * 12);
    double newMonthlyExpenses = account.monthlyExpenses + monthlyRepayment;

    if (newMonthlyExpenses < monthlyIncome * 0.5 && monthlyRepayment < monthlyIncome * 0.3) {
      Loan newLoan = Loan(amount: amount, termYears: years, interestRate: rate);
      account.loans.add(newLoan);
      account.deposit(amount);  // Simuler le dépôt du montant du prêt
      return true;
    }
    return false;
  }


  static Map<String, dynamic>? getBankAccountDetails(
      String bankName, String accountType) {
    var foundBank = bankData.firstWhere((bank) => bank['name'] == bankName,
        orElse: () => null);
    if (foundBank != null) {
      var foundAccount = foundBank['accounts'].firstWhere(
          (account) => account['type'] == accountType,
          orElse: () => null);
      return foundAccount;
    }
    return null;
  }
}
