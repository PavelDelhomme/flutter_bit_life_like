import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/business.dart';
import '../../services/bank/bank_account.dart';

class BusinessManagementService {
  void startBusiness(Person person, String name, String type, double investment) {
    if (person.bankAccounts.isNotEmpty && person.bankAccounts.first.balance >= investment) {
      person.startBusiness(name, type, investment);
      person.bankAccounts.first.withdraw(investment);
      print("${person.name} has started a new business: ${name} with ${investment}\$.");
    } else {
      print("Insufficient funds to start a new business.");
    }
  }

  void manageBusiness(Person person) {
    person.businesses.forEach((business) {
      business.payExpenses(500);
      print("Business: ${business.name}, Balance: ${business.getBalance()}");
    });
  }

  void handleTaxes(Business business) {
    double taxes = business.calculateTax();
    business.payExpenses(taxes);
    print("Paid taxes: \$${taxes} for ${business.name}");
  }

  void calculateExpenses(Business business) {
    double employeeExpenses = business.employees.fold(0, (sum, e) => sum + e.salary);
    business.payExpenses(employeeExpenses);
    print("Paid employee expenses for ${business.name}");
  }
}
