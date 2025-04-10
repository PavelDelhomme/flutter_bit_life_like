import 'package:bitlife_like/models/asset/real_estate.dart';
import 'package:bitlife_like/models/person/character.dart';

class BusinessLoan {
  final String businessId;
  final double amount;
  final double interestRate;
  final DateTime startDate;
  final int termMonths;
  double remainingBalance;

  BusinessLoan({
    required this.businessId,
    required this.amount,
    required this.interestRate,
    required this.termMonths,
  }) : startDate = DateTime.now(), remainingBalance = amount * (1 + interestRate);

  double calculateMonthlyPayment() {
    return remainingBalance / termMonths;
  }

  void makePayment(Business business) {
    double payment = calculateMonthlyPayment();
    business.capital -= payment;
    remainingBalance -= payment;
  }
}

class Business {
  final String id;
  final String name;
  final String industry;
  final String country;
  double capital;
  double valuation;
  List<Employee> employees;
  Map<String, double> skillRequirements;
  List<BusinessLoan> loans;
  List<RealEstate> properties;

  Map<String, double> requiredSkills = {
    'management': 3.0,
    'accounting': 2.5,
    'marketing': 2.0
  };

  Business({
    required this.name,
    required this.industry,
    required this.capital,
    required this.country,
    required this.loans,
    required this.skillRequirements,
    this.valuation = 0,
    List<Employee>? employees,
    List<RealEstate>? properties,
}) :
  id = 'biz_${DateTime.now().millisecondsSinceEpoch}',
  employees = employees ?? [],
  properties = properties ?? [];

  double calculateMonthlyProfit() {
    double expenses = employees.fold(0.0, (sum, e) => sum + e.salary);
    double income = valuation * 0.05; // 5% de la valorisation
    return income - expenses - _calculateLoanPayments();
  }

  double _calculateLoanPayments() {
    return loans.fold(0.0, (sum, loan) => sum + loan.calculateMonthlyPayment());
  }

  void hireEmployee(Employee employee) {
    if (capital >= employee.salary * 3) {
      employees.add(employee);
      capital -= employee.signingBonus;
    }
  }

  void takeLoan(BusinessLoan loan) {
    if (loan.amount > capital * 3) throw Exception("Ratio dette/capital trop élevé");
    capital += loan.amount;
    loans.add(loan);
  }

  bool canHire(Character owner) {
    return requiredSkills.entries.every((entry) {
      final skillLevel = owner.skillLevels[entry.key]?. ?? 0;
    })
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'industry': industry,
      "capital": capital,
      "valuation": valuation,
      "employees": employees,
      "skillRequirements": skillRequirements,
      "loans": loans,
      "properties": properties,
    };
  }

  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return {
      "id": json["id"],
      "name": json["name"],
      "country": json["country"],
      "industry": json["industry"],
      "capital": json["capital"],
      "valuation": json["valuation"],
      "employees": json["employees"],
      "skillRequirements": json["skillRequirements"],
      "loans": json["loans"],
      "properties": json["properties"],
    };
  }
}


class Employee {
  final String id;
  final String name;
  final String position;
  final double salary;
  final double signingBonus;

  Employee({
    required this.name,
    required this.position,
    required this.salary,
    this.signingBonus = 0,
  }) : id = 'emp_${DateTime.now().millisecondsSinceEpoch}';


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      "salary": salary,
      "signingBonus": signingBonus,
    };
  }

  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return {
      "id": json["id"],
      "name": json["name"],
      "position": json["position"],
      "salary": json["salary"],
      "signingBonus": json["signingBonus"],
    };
  }

}