
import 'band_account.dart';

class TransactionService {
  void transferFunds(BankAccount fromAccount, BankAccount toAccount, double amount) {
    if (fromAccount.balance >= amount) {
      fromAccount.withdraw(amount);
      toAccount.deposit(amount);
      print('Transferred $amount from ${fromAccount.toString()} to ${toAccount.toString()}.');
    } else {
      print('Insufficient funds to transfer.');
    }
  }
}
