import '../../Classes/person.dart';

class BankAccount {
  String accountNumber;
  String bankName;
  double balance;
  double annualIncome;
  double monthlyExpenses;
  int loanTermYears;
  double interestRate; // Pour gérer les intérêts sur les comptes
  String accountType; // Checking, Savings, etc.
  double closingFee;
  List<Loan> loans = [];
  List<String> accountHolders;

  BankAccount({
    required this.accountNumber,
    required this.bankName,
    required this.balance,
    this.annualIncome = 0,
    this.monthlyExpenses = 0,
    this.loanTermYears = 0,
    this.interestRate = 0.0,
    this.accountType = "Checking",
    this.closingFee = 1000,
    this.accountHolders = const [],
  });

  void deposit(double amount) {
    balance += amount;
    print('Deposited \$${amount.toStringAsFixed(2)} to $accountType account.');
  }
  double totalDebt() {
    return loans.fold(0.0, (sum, loan) => sum + loan.amount);
  }

  void withdraw(double amount) {
    if (amount <= balance) {
      balance -= amount;
      print(
          'Withdrew \$${amount.toStringAsFixed(2)} from $accountType account.');
    } else {
      print('Insufficient funds.');
    }
  }

  void applyForLoan(double amount, int years, double rate) {
    if (canApplyForLoan(amount, amount / (years * 12))) {
      Loan newLoan = Loan(amount: amount, termYears: years, interestRate: rate);
      loans.add(newLoan);
      balance += amount; // Assume immediate deposit for simplicity
      print(
          "Loan of \$${amount} approved for $years years at ${rate}% interest.");
    } else {
      print("Loan application denied due to credit policies.");
    }
  }

  bool canApplyForLoan(double amount, double monthlyRepayment) {
    double projectedMonthlyExpenses = monthlyExpenses + monthlyRepayment;
    return projectedMonthlyExpenses < 0.9 * (annualIncome / 12) &&
        amount <= annualIncome * 0.4;
  }

  void repayLoan(double amount) {
    Loan loan = loans.firstWhere((loan) => loan.amount >= amount,
        orElse: () => Loan(amount: 0, termYears: 0, interestRate: 0));
    if (loan.amount > 0 && amount <= balance) {
      loan.amount -= amount;
      balance -= amount;
      print("Repayed \$${amount} of loan, \$${loan.amount} remaining.");
    } else {
      print(
          'Insufficient funds to repay the loan or no appropriate loan found.');
    }
  }

  @override
  String toString() {
    return 'Account: $accountNumber, Balance: \$${balance.toStringAsFixed(2)}';
  }

  void closeAccount() {
    if (balance >= closingFee) {
      balance -= closingFee;
      print("Account closed. Fee of \$${closingFee} deducted.");
    } else {
      print("Insufficient funds to close the account.");
    }
  }
}

class Loan {
  double amount;
  int termYears;
  double interestRate;

  Loan(
      {required this.amount,
      required this.termYears,
      required this.interestRate});
}
class Bank {
  String name;
  List<BankAccount> accounts;

  Bank({required this.name, this.accounts = const []});

  BankAccount openAccount(String accountType, double initialDeposit, double interestRate, {bool isJoint = false, List<Person>? partners = const []}) {
    if (isJoint && (partners == null || partners.isEmpty)) {
      print("Cannot open a joint account without a partner.");
      throw Exception("Failed to open joint account: No partner provided.");
    }

    String accountNumber = "ACC${DateTime.now().millisecondsSinceEpoch}";
    BankAccount newAccount = BankAccount(
      accountNumber: accountNumber,
      bankName: this.name,
      balance: initialDeposit,
      interestRate: interestRate,
      accountType: accountType,
      closingFee: 1000,  // Default closing fee
    );

    accounts.add(newAccount);
    print("New $accountType account opened with \$${initialDeposit} initial deposit at ${this.name}.");
    return newAccount;
  }

  double getInterestRate(String accountType) {

  }
}

