import '../../Classes/person.dart';
import 'FinancialService.dart';
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
  void attemptPurchase(BankAccount account, double price, {bool useLoan = false, int loanTerm = 0, double loanInterestRate = 0.0, required Person person, required Function onPurchaseSuccess}) {
    if (useLoan && account.canApplyForLoan(price, price / (loanTerm * 12))) {
      bool loanApproved = FinancialService.instance.applyForLoan(account, price, loanTerm, loanInterestRate);
      if (loanApproved) {
        this.purchaseItem(account, price, () {
          print("Purchased with loan successfully!");
          onPurchaseSuccess();
        }, () {
          print("Failed to process loan purchase!");
        });
      } else {
        print("Loan was not approved.");
      }
    } else {
      this.purchaseItem(account, price, () {
        print("Purchase successful!");
        onPurchaseSuccess();
      }, () {
        print("Insufficient funds.");
      });
    }
  }

}
