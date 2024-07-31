class BankAccount {
  double balance;
  double loanAmount;

  BankAccount({required this.balance, this.loanAmount = 0});

  void deposit(double amount) {
    balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= balance) {
      balance -= amount;
    } else {
      print('Insufficient funds.');
    }
  }

  void applyLoan(double amount) {
    loanAmount += amount;
    balance += amount;
  }

  void repayLoan(double amount) {
    if (amount <= balance) {
      balance -= amount;
      loanAmount -= amount;
    } else {
      print('Insufficient funds to repay the loan.');
    }
  }

  @override
  String toString() {
    return 'Balance: \$${balance.toStringAsFixed(2)}, Loan: \$${loanAmount.toStringAsFixed(2)}';
  }
}
