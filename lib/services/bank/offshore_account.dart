import 'bank_account.dart';
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
