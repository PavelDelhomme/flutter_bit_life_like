import 'dart:math';

import '../person.dart';

class OffshoreAccount {
  String accountNumber;
  double balance;
  String country;

  OffshoreAccount(this.accountNumber, this.balance, this.country);
}

class TaxHavenService {
  static List<String> taxHavens = ['Switzerland', 'Cayman Islands', 'Panama'];

  static OffshoreAccount createOffshoreAccount(Person person) {
    // Crée un compte dans un paradis fiscal
    String taxHaven = taxHavens[Random().nextInt(taxHavens.length)];
    String accountNumber = 'OFF${Random().nextInt(100000)}';
    OffshoreAccount offshoreAccount = OffshoreAccount(accountNumber, 0.0, taxHaven);
    print("${person.name} created an offshore account in $taxHaven with account number $accountNumber.");
    return offshoreAccount;
  }
}
