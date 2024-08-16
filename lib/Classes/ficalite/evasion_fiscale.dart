import 'dart:math';

import '../../services/bank/bank_account.dart';
import '../person.dart';

class OffshoreAccount extends BankAccount {
  final String taxHavenCountry;

  OffshoreAccount({
    required String accountNumber,
    required String bankName,
    required double balance,
    required this.taxHavenCountry,
    double interestRate = 0.0,
    String accountType = "Offshore",
    double closingFee = 1000,
  }) : super(
    accountNumber: accountNumber,
    bankName: bankName,
    balance: balance,
    interestRate: interestRate,
    accountType: accountType,
    closingFee: closingFee,
  );
}

class TaxHavenService {
  static List<String> taxHavens = ['Switzerland', 'Cayman Islands', 'Panama'];

  static OffshoreAccount createOffshoreAccount(Person person, double initialDeposit) {
    String taxHaven = taxHavens[Random().nextInt(taxHavens.length)];
    String accountNumber = 'OFF${Random().nextInt(100000)}';
    OffshoreAccount offshoreAccount = OffshoreAccount(
      accountNumber: accountNumber,
      bankName: taxHaven + " Bank",
      balance: initialDeposit,
      taxHavenCountry: taxHaven,
    );
    person.offshoreAccounts.add(offshoreAccount);
    print("${person.name} created an offshore account in $taxHaven with account number $accountNumber.");
    return offshoreAccount;
  }
}
