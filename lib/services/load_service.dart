
import 'band_account.dart';

class LoanService {
  void applyForLoan(BankAccount account, double amount) {
    account.applyLoan(amount);
    // Logique pour gérer les termes du prêt et le remboursement
    print('Loan of $amount approved.');
  }
}
