import 'bank_account.dart';

class LoanService {
  void applyForLoan(BankAccount account, double amount, Function onApproval, Function onError) {
    if (account.canApplyForLoan(amount, amount / (account.loanTermYears * 12))) {
      account.applyLoan(amount, account.loanTermYears);
      onApproval();
    } else {
      onError("Credit insufficient for the loan amount requested.");
    }
  }
}
