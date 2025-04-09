import 'dart:math';

class Loan {
  final double amount;
  final int termYears;
  final double interestRate;
  final String purpose;
  final DateTime startDate;
  double remainingAmount;
  int missed = 0;
  bool isDefaulted = false;
  
  Loan({
    required this.amount,
    required this.termYears,
    required this.interestRate,
    required this.purpose,
    required this.startDate,
  }) : remainingAmount = amount;
  
  double calculateMonthlyPayment() {
    double rate = interestRate / 100 / 12;
    int payments = termYears * 12;
    return amount * (rate * pow(1 + rate, payments)) / (pow(1 + rate, payments) - 1);
  }
  
  void makePayment(double payment) {
    remainingAmount -= payment;
    if (remainingAmount <= 0) {
      remainingAmount = 0;
    }
  }
  
  // Vérification du défaut de paiement
  void checkDefault() {
    if (missed >= 3) {
      isDefaulted = true;
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'termYears': termYears,
      'interestRate': interestRate,
      'purpose': purpose,
      'startDate': startDate.toIso8601String(),
      'remainingAmount': remainingAmount,
      'missed': missed,
      'isDefaulted': isDefaulted,
    };
  }
  
  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      amount: json['amount'],
      termYears: json['termYears'],
      interestRate: json['interestRate'],
      purpose: json['purpose'],
      startDate: DateTime.parse(json['startDate']),
    )
      ..remainingAmount = json['remainingAmount']
      ..missed = json['missed']
      ..isDefaulted = json['isDefaulted'];
  }
}
