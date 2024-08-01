class BankAccount {
  double balance;
  double loanAmount;
  double annualIncome;
  double monthlyExpenses;
  int loanTermYears;

  BankAccount({required this.balance, this.loanAmount = 0, required this.annualIncome, this.monthlyExpenses = 0, this.loanTermYears = 0});

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

  void applyLoan(double amount, int years) {
    loanTermYears = years;
    double monthlyRepayment = amount / (years * 12);
    if (canApplyForLoan(amount, monthlyRepayment)) {
      loanAmount += amount;
      balance += amount;
      monthlyExpenses += monthlyRepayment;
      print("Loan of \$${amount} approved for ${years} years.");
    } else {
      print("Loan application denied.");
    }
  }


  bool canApplyForLoan(double amount, double monthlyRepayment) {
    double projectedMonthlyExpenses = monthlyExpenses + monthlyRepayment;
    return projectedMonthlyExpenses < 0.9 * (annualIncome / 12) && amount <= annualIncome * 0.4;
  }

  void repayLoan(double amount) {
    if (amount <= balance) {
      balance -= amount;
      loanAmount -= amount;
      monthlyExpenses -= amount / (loanTermYears * 12);
    } else {
      print('Insufficient funds to repay the loan.');
    }
  }

  @override
  String toString() {
    return 'Balance: \$${balance.toStringAsFixed(2)}, Loan: \$${loanAmount.toStringAsFixed(2)}';
  }
}
