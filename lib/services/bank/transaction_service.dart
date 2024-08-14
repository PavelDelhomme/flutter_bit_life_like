import 'package:bit_life_like/Classes/objects/collectible_item.dart';

import '../../Classes/person.dart';
import 'FinancialService.dart';
import 'bank_account.dart';

class TransactionService {
  Future<void> purchaseItem(BankAccount account, double price, Function onSuccess, Function onFailure) async {
    if (account.balance >= price) {
      account.withdraw(price);
      onSuccess();
    } else {
      onFailure("Insufficient funds.");
    }
  }

  Future<void> attemptPurchase(BankAccount account, CollectibleItem item, {bool useLoan = false, int loanTerm = 0, double loanInterestRate = 0.0, required Function onSuccess, required Function onFailure}) async {
    double price = item.value;
    if (useLoan) {
      bool loanApproved = await FinancialService.instance.applyForLoan(account, price, loanTerm, loanInterestRate);
      if (loanApproved) {
        account.withdraw(price);
        onSuccess();
      } else {
        onFailure("Loan was not approved.");
      }
    } else {
      if (account.balance >= price) {
        account.withdraw(price);
        onSuccess();
      } else {
        onFailure("Insufficient funds.");
      }
    }
  }

  Future<void> sellItem(Person person, CollectibleItem item, BankAccount account, double salePrice, Function onSuccess, Function onFailure) async {
    try {
      account.deposit(salePrice);
      person.collectibles.remove(item);
      //_removeItemFromPerson(person, item);
      onSuccess();
    } catch (e) {
      onFailure("Failed to sell item: ${e.toString()}");
    }
  }

}
