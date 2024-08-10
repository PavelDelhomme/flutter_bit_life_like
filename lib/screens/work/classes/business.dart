class Business {
  String name;
  String type;
  double initialInvestment;
  double income = 0;
  double expenses = 0;
  List<String> products = [];
  List<String> employees = [];
  List<String> departments = [];
  bool isPublic = false;

  Business({
    required this.name,
    required this.type,
    required this.initialInvestment,
  });

  double getBalance() {
    return income - expenses;
  }

  void addProduct(String product) {
    products.add(product);
  }

  void hireEmployee(String employee) {
    employees.add(employee);
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
}
