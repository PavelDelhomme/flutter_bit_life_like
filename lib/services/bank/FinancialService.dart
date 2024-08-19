import 'dart:convert';
import 'dart:math';

import 'package:bit_life_like/services/bank/fiscal_control_service.dart';
import 'package:flutter/services.dart';

import '../../Classes/life_history_event.dart';
import '../../Classes/person.dart';
import 'bank_account.dart';

class FinancialService {
  FinancialService._privateConstructor();

  static final FinancialService _instance =
      FinancialService._privateConstructor();
  static FinancialService get instance => _instance;

  
  static double _inflationRate = 0.02; // Par défaut 2% d'inflation annuelle
  
  static double get inflationRate => _inflationRate;

  static void deposit(BankAccount account, double amount, Person person) {
    account.deposit(amount);
    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "${person.name} deposited \$${amount.toStringAsFixed(2)} into ${account.accountType} account.",
      timestamp: DateTime.now(),
      ageAtEvent: person.age,
      personId: person.id,  // Ajout de l'identifiant de la personne
    ));
    print("Deposited \$${amount.toStringAsFixed(2)} to ${account.accountType} account.");
  }

  static void withdraw(BankAccount account, double amount, Person person) {
    account.withdraw(amount);
    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "${person.name} withdrew \$${amount.toStringAsFixed(2)} from ${account.accountType} account.",
      timestamp: DateTime.now(),
      ageAtEvent: person.age,
      personId: person.id,  // Ajout de l'identifiant de la personne
    ));
    print("Withdrew \$${amount.toStringAsFixed(2)} from ${account.accountType} account.");
  }

  static void updateInflationRate(double newRate) {
    _inflationRate = newRate;
  }

  static double applyInflation(double amount) {
    return amount * (1 + _inflationRate);
  }

  static void applyAnnualInflation() {
    _inflationRate += Random().nextDouble() * 0.03 - 0.015; // Inflation entre -1,5% et 1.5%
    _inflationRate = _inflationRate.clamp(0.0, 0.1);
    print("New Inflation Rate : ${(inflationRate * 100).toStringAsFixed(2)}%");
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

  bool investInStock(BankAccount account, double amount, Person person) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "${person.name} invested \$${amount.toStringAsFixed(2)} in stocks.",
        timestamp: DateTime.now(),
        ageAtEvent: person.age,
        personId: person.id,  // Ajout de l'identifiant de la personne
      ));
      print('Invested \$$amount in stocks.');
      return true;
    } else {
      print('Insufficient funds to invest in stocks.');
      return false;
    }
  }

  bool investInCrypto(BankAccount account, double amount, Person person) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "${person.name} invested \$${amount.toStringAsFixed(2)} in crypto.",
        timestamp: DateTime.now(),
        ageAtEvent: person.age,
        personId: person.id,  // Ajout de l'identifiant de la personne
      ));
      print("Invested $amount in crypto.");
      return true;
    } else {
      print("Insufficient funds to invest in crypto.");
      return false;
    }
  }

  void buyBonds(BankAccount account, double amount, Person person) {
    if (account.balance >= amount) {
      account.withdraw(amount);
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "${person.name} invested \$${amount.toStringAsFixed(2)} in crypto.",
        timestamp: DateTime.now(),
        ageAtEvent: person.age,
        personId: person.id,  // Ajout de l'identifiant de la personne
      ));
      print("Bought bonds for $amount.");
    } else {
      print("Insufficient funds to buy bonds.");
    }
  }

  bool applyForLoan(BankAccount account, double amount, int years, double rate) {
    return account.canApplyForLoan(amount, amount / (years * 12));
    /*
    double monthlyIncome = account.annualIncome / 12;
    double monthlyRepayment = amount / (years * 12);
    double newMonthlyExpenses = account.monthlyExpenses + monthlyRepayment;

    if (newMonthlyExpenses < monthlyIncome * 0.5 && monthlyRepayment < monthlyIncome * 0.3) {
      Loan newLoan = Loan(amount: amount, termYears: years, interestRate: rate);
      account.loans.add(newLoan);
      account.deposit(amount);  // Simuler le dépôt du montant du prêt
      return true;
    }
    return false;*/
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

  void performFiscalControl(Person person) {
    bool foundFraud = FiscalControlService().performFiscalControl(person);

    if (foundFraud) {
      double fine = person.calculateAnnualIncome() * 0.3; // Amende de 30% des revenus annuels
      person.bankAccounts.first.withdraw(fine);
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "Fiscal control detected fraud. Fine applied: \$${fine.toStringAsFixed(2)}",
        timestamp: DateTime.now(),
        ageAtEvent: person.age,
        personId: person.id
      ));
    } else {
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "Fiscal control completed. No fraud detected.",
        timestamp: DateTime.now(),
        ageAtEvent: person.age,
        personId: person.id
      ));
    }
  }


}
