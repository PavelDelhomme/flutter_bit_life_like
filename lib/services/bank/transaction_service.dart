import 'bank_account.dart';

class TransactionService {
  void purchaseItem(BankAccount account, double price, Function onSuccess,
      Function onFailure) {
    if (account.balance >= price) {
      account.withdraw(price);
      onSuccess();
    } else {
      onFailure("Insufficient funds.");
    }
  }
}
