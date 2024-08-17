import 'dart:math';

import 'package:bit_life_like/Classes/ficalite/tax_system.dart';

import '../../../Classes/person.dart';
import '../../../services/bank/bank_account.dart';

class Business {
  String name;
  String type;
  double initialInvestment;
  double income = 0;
  double expenses = 0;
  double taxRate = 0.25;
  double amortizationRate = 0.05; // 5% par année
  List<Product> products = [];
  List<Employee> employees = [];
  List<Department> departments = [];
  List<Strategy> strategies = [];
  bool isPublic = false;
  Map<String, String> swotAnalysis = {};
  BankAccount? businessAccount;
  bool isEngagedInFraud = false;

  Business({
    required this.name,
    required this.type,
    required this.initialInvestment,
    this.businessAccount,
  });

  double getBalance() {
    return income - expenses;
  }

  double calculateTax() {
    return income * taxRate;
  }

  double calculateAmortization() {
    double amortization = initialInvestment * amortizationRate;
    return amortization;
  }

  void applyAmortization() {
    double amortization = calculateAmortization();
    income -= amortization; // Réduire le revenu imposable avec l'amortissement
    print(
        "Applied amortization of \$${amortization.toStringAsFixed(2)} for ${name}");
  }

  double calculateAnnualProfit() {
    return (income - expenses) * 12;
  }

  double calculateBusinessTaxes() {
    double annualProfit = calculateAnnualProfit();
    TaxSystem taxSystem = TaxSystem();
    return taxSystem.calculateCorporateTax(annualProfit);
  }

  void payTaxes() {
    double taxes = calculateTax();
    expenses += taxes;
    if (businessAccount != null) {
      businessAccount!.withdraw(taxes);
    }
    print("Paid taxes: \$${taxes.toStringAsFixed(2)}");
  }

  void paySalaries() {
    for (var employee in employees) {
      expenses += employee.salary;
      if (businessAccount != null) {
        businessAccount!.withdraw(employee.salary);
        print(
            "Paid salary of ${employee.name}: \$${employee.salary.toStringAsFixed(2)}");
      }
    }
  }

  void addProduct(String product) {
    products.add(Product(name: product, price: 100, productionCost: 50));
  }

  void hireEmployee(String name, double salary, Department department) {
    Employee employee = Employee(name: name, salary: salary);
    employees.add(employee);
    department.addEmployee(employee);
    expenses += salary;
  }

  void fireEmployee(String name) {
    Employee employeeFired =
        employees.where((employee) => employee.name == name) as Employee;
    expenses -= employeeFired.salary;
    employees.removeWhere((employee) => employee.name == name);
  }


  void addDepartment(String department) {
    departments.add(Department(name: department));
  }

  void payExpenses(double amount) {
    expenses += amount;
    if (businessAccount != null) {
      businessAccount!.withdraw(amount);
    }
  }

  void generateIncome(double amount) {
    income += amount;
    if (businessAccount != null) {
      businessAccount!.deposit(amount);
    }
  }

  void listProducts() {
    print("Products: ${products.map((p) => p.name).join(', ')}");
  }

  void listEmployees() {
    print("Employees: ${employees.map((e) => e.name).join(', ')}");
  }

  void listDepartments() {
    print("Departments: ${departments.map((d) => d.name).join(', ')}");
  }

  // Business Management
  void addStrategy(Strategy strategy) {
    strategies.add(strategy);
  }

  void setSWOTAnalysis(
      String strength, String weakness, String opportunity, String threat) {
    swotAnalysis['Strength'] = strength;
    swotAnalysis['Weakness'] = weakness;
    swotAnalysis['Opportunity'] = opportunity;
    swotAnalysis['Threat'] = threat;
  }

  void conductMarketingCampaign(String campaign) {
    print("Conducted marketing campaign: $campaign");
    // Cela sera gérer avecv le système d'alétoire lorsque l'ont passe une année donc cela ne génèrera pas de revenu la enfaite
    // Il faut juste prendre en compte que cela a plus ou moins de chance de marcher lorsque l'ont fait une campagne
    // de marqueting pour le moment c'est pas mis en place le système d'évènement alétoire
    // donc cela ne génèrera pas de plus ou moins pour le moment cela dépendra de vente qu'il faut prendre encomte
    //
  }

  void expandInternationally(String market) {
    print("Expanding into internationnal market : $market}");
  }

  void automateProcesses() {
    print("Automating business process.");
  }

  void engageInCSR(String initiative) {
    print("Improve public perception and potentially increase income");
    // Se fera en fonction d'évènement et de directeion prise par l'entreprise avec des choix
    // Proposer au fur et a mesure du jeux qui sera gérer avec le système de décision et
    // de choix et d'aléatoire plus tard
  }

  void transferOwnershipTo(Person successor) {
    print("Transferring ownership to $successor");
  }

  void getNetValue() {
    double netValue = getBalance() + businessAccount!.balance;
    print("Net Value of Business : \$${netValue.toStringAsFixed(2)}");
  }

  void interactWithEmployee(String name) {
    Employee? employee = employees.firstWhere((e) => e.name == name);
    if (employee != null) {
      print("Interacting with ${employee.name}");
      // Ajouter les logique d'interaction
    }
  }

  void engageInTaxFraud() {
    // Simule la fraude fiscale
    isEngagedInFraud = true;
    double hiddenRevenue = income * 0.2; // Cache 20% du revenu
    expenses -= hiddenRevenue;
    print("${name} is engaging in tax fraud and hiding \$${hiddenRevenue.toStringAsFixed(2)} from taxes.");
  }

  void handleAudit() {
    // Simule un audit fiscal
    if (isEngagedInFraud && Random().nextDouble() < 0.3) {
      double fine = income * 0.5; // Amende de 50% des revenus cachés
      expenses += fine;
      isEngagedInFraud = false; // L'entreprise arrête la fraude après s'être fait prendre
      print("${name} has been caught in tax fraud and fined \$${fine.toStringAsFixed(2)}.");
    } else {
      print("${name} passed the audit without issues.");
    }
  }

  void processAnnualUpdate() {
    // Générer les revenus pour l'année
    double annualIncome = generateIncomeForYear();
    generateIncome(annualIncome);

    // Appliquer l'ammortissement
    applyAmortization();

    // Payer les salaire
    paySalaries();

    // Calculer et payer les taxes
    double taxes = calculateBusinessTaxes();
    payTaxes();

    // Effectuer un audit pour détecter une éventuelle fraude
    handleAudit();

    print("${name}'s annual update completed");
  }

  double generateIncomeForYear() {
    // Exemple de revenu aléatoire pour l'année
    return Random().nextDouble() * 100000;
  }
}

class Employee {
  String name;
  double salary;

  Employee({
    required this.name,
    required this.salary,
  });
}

class Product {
  String name;
  double price;
  double productionCost;

  Product({
    required this.name,
    required this.price,
    required this.productionCost,
  });
}

class Department {
  String name;
  List<Employee> employees = [];

  Department({required this.name});

  void addEmployee(Employee employee) {
    employees.add(employee);
  }
}

class Strategy {
  String description;

  Strategy(this.description);
}
