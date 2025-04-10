import 'dart:math';
import 'loan.dart' as loann;

enum AccountType {
  checking,
  savings,
  investment,
  retirement,
  business,
  joint
}

class BankAccount {
  String id;
  String accountNumber;
  String bankName;
  AccountType accountType;
  double balance;
  double interestRate;
  List<String> accountHolders;
  List<Transaction> transactions;
  List<loann.Loan> loans;
  DateTime openedDate;
  double monthlyFee;
  bool isActive;

  // Calcul des intérêts mensuels
  double get monthlyInterest => balance * (interestRate / 100 / 12);

  // Dette totale
  double get totalDebt => loans.fold(0.0, (sum, loan) => sum + loan.remainingAmount);

  BankAccount({
    required this.id,
    required this.accountNumber,
    required this.bankName,
    required this.accountType,
    this.balance = 0.0,
    this.interestRate = 0.001,
    List<String>? accountHolders,
    List<Transaction>? transactions,
    List<loann.Loan>? loans,
    DateTime? openedDate,
    this.monthlyFee = 0.0,
    this.isActive = true,
  }) : 
    accountHolders = accountHolders ?? [],
    transactions = transactions ?? [],
    loans = loans ?? [],
    openedDate = openedDate ?? DateTime.now();

  void deposit(double amount, description) {
    if (amount <= 0) throw Exception("Le montant doit être positif");
    balance += amount;
    transactions.add(Transaction(
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.deposit,
      description: description
    ));
  }

  
  bool withdraw(double amount, String description) {
    if (amount <= 0) throw Exception("Le montant doit être positif");
    if (amount > balance) return false;
    
    balance -= amount;
    transactions.add(Transaction(
      amount: -amount,
      description: description,
      date: DateTime.now(),
      type: TransactionType.withdrawal
    ));
    return true;
  }

  
  bool transfer(BankAccount target, double amount, String description) {
    if (withdraw(amount, "Transfert vers ${target.accountNumber}")) {
      target.deposit(amount, "Transfert depuis ${accountNumber}");
      return true;
    }
    return false;
  }

  // Demande de prêt
  loann.Loan? applyForLoan(double amount, int termYears, String purpose) {
    // Evaluation de la solvabilité
    double monthlyPayment = calculateMonthlyPayment(amount, termYears);
    double debtToIncomeRatio = monthlyPayment / (accountHolders.length * 1000); // Simulation
    
    if (debtToIncomeRatio < 0.4 && loans.length < 3) {
      loann.Loan newLoan = loann.Loan(
        amount: amount,
        termYears: termYears,
        interestRate: 5.0 + (loans.length * 1.5), // Taux augmente avec le nombre de prêts
        purpose: purpose,
        startDate: DateTime.now(), // Ajout du paramètre manquant
      );

      loans.add(newLoan);
      balance += amount;

      transactions.add(Transaction(
        amount: amount,
        date: DateTime.now(),
        type: TransactionType.loan,
        description: "Prêt: $purpose"
      ));

      return newLoan;
    }

    return null;
  }


  // Calcul du paiement mensuel pour un prêt
  double calculateMonthlyPayment(double principal, int termYears) {
    double rate = interestRate / 100 / 12;
    int payments = termYears * 12;
    return principal * (rate * pow(1 + rate, payments)) / (pow(1 + rate, payments) - 1);
  }

  // Application des intérêts mensuels
  void applyMonthlyInterest() {
    double interest = monthlyInterest;
    if (interest > 0) {
      balance += interest;
      transactions.add(Transaction(
        amount: interest,
        date: DateTime.now(),
        type: TransactionType.interest,
        description: "Interêts"
      ));
    }
  }

  // Payement mensuel de tous les prêts
  void processMonthlyLoanPayments() {
    for (var loan in loans) {
      double payment = loan.calculateMonthlyPayment();
      if (balance >= payment) {
        balance -= payment;
        loan.makePayment(payment);
        transactions.add(Transaction(
          amount: -payment,
          date: DateTime.now(),
          type: TransactionType.loanPayment,
          description: "Payment mensuel du prêt"
        ));
      } else {
        // Défaut de paiement
        loan.missed++;
        transactions.add(Transaction(
          amount: 0,
          date: DateTime.now(),
          type: TransactionType.missed,
          description: "Payment mensuel du prêt non passer"
        ));
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'accountType': accountType.toString(),
      'balance': balance,
      'interestRate': interestRate,
      'accountHolders': accountHolders,
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'loans': loans.map((l) => l.toJson()).toList(),
      'openedDate': openedDate.toIso8601String(),
      'monthlyFee': monthlyFee,
      'isActive': isActive,
    };
  }

  
  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      accountType: AccountType.values.firstWhere(
        (e) => e.toString() == json['accountType'],
        orElse: () => AccountType.checking
      ),
      balance: json['balance'],
      interestRate: json['interestRate'],
      accountHolders: List<String>.from(json['accountHolders']),
      transactions: (json['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
      loans: (json['loans'] as List)
          .map((l) => loann.Loan.fromJson(l))
          .toList(),
      openedDate: DateTime.parse(json['openedDate']),
      monthlyFee: json['monthlyFee'],
      isActive: json['isActive'],
    );
  }
}





// Classe pour le compte offshore
class OffshoreAccount extends BankAccount {
  String taxHavenCountry;
  double taxEvasionRisk;
  
  OffshoreAccount({
    required super.id,
    required super.accountNumber,
    required super.bankName,
    required this.taxHavenCountry,
    this.taxEvasionRisk = 0.2,
    super.balance = 0.0,
    super.interestRate = 2.5, // Taux élevés dans les paradis fiscaux
  }) : super(accountType: AccountType.checking);
  
  // Transfert avec anonymisation
  bool anonymousTransfer(BankAccount target, double amount) {
    if (balance < amount) return false;
    
    bool detected = Random().nextDouble() < taxEvasionRisk;
    if (detected) {
      // Risque de détection augmente à chaque utilisation
      taxEvasionRisk += 0.1;
    }
    
    balance -= amount;
    target.balance += amount;
    return true;
  }
}

// Historique des transactions
enum TransactionType {
  deposit,
  withdrawal,
  transfer,
  interest,
  loan,
  loanPayment,
  fee,
  tax,
  missed
}

class Transaction {
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  
  Transaction({
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description.toString(),
      'type': type.toString(),
    };
  }
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.transfer
      ),
    );
  }
}