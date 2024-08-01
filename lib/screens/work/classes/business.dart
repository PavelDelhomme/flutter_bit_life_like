class Business {
  String name;
  String type;
  double initialInvestment;
  double balance;

  Business({required this.name, required this.type, required this.initialInvestment}) : balance = initialInvestment;

  void invest(double amount) {
    balance += amount;
    print("Invested \$${amount} in ${name}");
  }

  void payExpenses(double amount) {
    if (balance >= amount) {
      balance -= amount;
      print("Expenses of \$${amount} paid for ${name}");
    } else {
      print("Insufficient funds to cover expenses for ${name}");
    }
  }

  double getBalance() {
    return balance;
  }
}
