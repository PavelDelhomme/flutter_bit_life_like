
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../Classes/person.dart';
import 'bank_account.dart';

class FinancialService {
  FinancialService._privateConstructor();

  static final FinancialService _instance = FinancialService._privateConstructor();

  static FinancialService get instance => _instance;


  static List<dynamic> bankData = [];

  static Future<void> loadBankData() async {
    final String response = await rootBundle.loadString('assets/banks.json');
    bankData = json.decode(response)['banks'];
  }

  static double getInterestRate(String bankName, String accountType) {
    var foundBank = bankData.firstWhere((bank) => bank['name' == bankName], orElse: () => null);
    if (foundBank != null) {
      var foundAccount = foundBank['accounts'].firstWhere((account) => account['type'] == accountType, orElse: () => null);
      return foundAccount != null ? foundAccount['interestRate'] : 0.0;
    }
    return 0.0;
  }

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
  bool applyForLoan(BankAccount account, double amount, int years, double rate) {
    if (account.canApplyForLoan(amount, amount / (years * 12))) {
      Loan newLoan = Loan(amount: amount, termYears: years, interestRate: rate);
      account.loans.add(newLoan);
      account.balance += amount;  // Assuming the loan amount is immediately available in the balance
      print("Loan of \$${amount} approved for $years years at $rate% interest.");
      return true;  // Indicate success
    } else {
      print("Loan application denied due to credit policies.");
      return false;  // Indicate failure
    }
  }




  static Map<String, dynamic>? getBankAccountDetails(String bankName, String accountType) {
    var foundBank = bankData.firstWhere((bank) => bank['name'] == bankName, orElse: () => null);
    if (foundBank != null) {
      var foundAccount = foundBank['accounts'].firstWhere((account) => account['type'] == accountType, orElse: () => null);
      return foundAccount;
    }
    return null;
  }


}