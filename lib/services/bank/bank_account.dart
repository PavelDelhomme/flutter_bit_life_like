import '../../Classes/person.dart';
import 'FinancialService.dart';

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
  List<Loan> loans;
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
    List<Loan>? loans,
    List<String>? accountHolders,
  }) : loans = loans ?? [],
       accountHolders = accountHolders ?? [];

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

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    var loanList = json['loans'] as List<dynamic>? ?? [];
    List<Loan> loans = loanList.map((loanJson) => Loan.fromJson(loanJson as Map<String, dynamic>)).toList();
    var holdersList = json['accountHolders'] as List<dynamic>? ?? [];
    List<String> holders = holdersList.map((holder) => holder as String).toList();

    return BankAccount(
      accountNumber: json['accountNumber'] as String,
      bankName: json['bankName'] as String,
      balance: (json['balance'] as num).toDouble(),
      annualIncome: (json['annualIncome'] as num?)?.toDouble() ?? 0,
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toDouble() ?? 0,
      loanTermYears: json['loanTermYears'] as int? ?? 0,
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
      accountType: json['accountType'] as String? ?? "Checking",
      closingFee: (json['closingFee'] as num?)?.toDouble() ?? 1000,
      loans: loans,
      accountHolders: holders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'bankName': bankName,
      'balance': balance,
      'annualIncome': annualIncome,
      'monthlyExpenses': monthlyExpenses,
      'loanTermYears': loanTermYears,
      'interestRate': interestRate,
      'accountType': accountType,
      'closingFee': closingFee,
      'loans': loans.map((loan) => loan.toJson()).toList(),
      'accountHolders': accountHolders,
    };
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

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      amount: (json['amount'] as num).toDouble(),
      termYears: json['termYears'] as int,
      interestRate: (json['interestRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'termYears': termYears,
      'interestRate': interestRate,
    };
  }
}
class Bank {
  String name;
  List<BankAccount> accounts;

  Bank({required this.name, List<BankAccount>? accounts}) : accounts = accounts ?? <BankAccount>[];

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

  bool evaluateBusinessLoan(Person person, double amount, int termYears, double projectedRevenue) {
    // Basic logic to evaluate loan based on projected revenue and other factors
    double minimumRequiredRevenue = amount * 0.8;
    if (projectedRevenue >= minimumRequiredRevenue) {
      return true;
    }
    return false;
  }

  double getInterestRate(String accountType) {
    var accountDetails = FinancialService.getBankAccountDetails(this.name, accountType);
    return accountDetails != null ? accountDetails['interestRate'] : 0.0;
  }

}

abstract class Purchasable {
  double get value; // Le prix du bien
}

