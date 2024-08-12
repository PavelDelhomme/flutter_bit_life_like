import '../../../Classes/person.dart';

class Business {
  String name;
  String type;
  double initialInvestment;
  double income = 0;
  double expenses = 0;
  double taxRate = 0.25;
  List<String> products = [];
  List<Employee> employees = [];
  List<String> departments = [];
  List<String> strategies = [];
  bool isPublic = false;
  Map<String, String> swotAnalysis = {};


  Business({
    required this.name,
    required this.type,
    required this.initialInvestment,
  });

  double getBalance() {
    return income - expenses;
  }

  double calculateTax() {
    return income * taxRate;
  }

  void addProduct(String product) {
    products.add(product);
  }

  void hireEmployee(String name, double salary) {
    employees.add(Employee(name: name, salary: salary));
  }

  void fireEmployee(String name) {
    employees.removeWhere((employee) => employee.name == name);
  }

  void paySalaries() {
    for (var employee in employees) {
      expenses += employee.salary;
    }
  }

  void addDepartment(String department) {
    departments.add(department);
  }

  void payExpenses(double amount) {
    expenses += amount;
  }

  void generateIncome(double amount) {
    income += amount;
  }

  void listProducts() {
    print("Products: ${products.join(', ')}");
  }

  void listEmployees() {
    print("Employees: ${employees.join(', ')}");
  }

  void listDepartments() {
    print("Departments: ${departments.join(', ')}");
  }

  // Business Management
  void addStrategy(String strategy) {
    strategies.add(strategy);
  }

  void setSWOTAnalysis(String strength, String weakness, String opportunity, String threat) {
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
}

class Employee {
  String name;
  double salary;

  Employee({
    required this.name,
    required this.salary,
  });

}
