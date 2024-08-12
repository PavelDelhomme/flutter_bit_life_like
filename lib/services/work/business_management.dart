import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/business.dart';
import '../../services/bank/bank_account.dart';

class BusinessManagementService {
  void startBusiness(Person person, String name, String type, double investment, BankAccount businessAccount) {
    if (person.realEstates.isNotEmpty && person.bankAccounts.isNotEmpty) {
      if (businessAccount.balance >= investment) {
        person.startBusiness(name, type, investment); // Adjusted to call the correct method
        businessAccount.withdraw(investment);
        print("${person.name} has started a new business: ${name} with ${investment}\$.");
      } else {
        print("Insufficient funds to start a new business.");
      }
    } else {
      print("Real estate ownership is required to start a business.");
    }
  }

  void addProductToBusiness(Business business, Product product) {
    business.addProduct(product.name);
    print("Added product ${product.name} to business ${business.name}.");
  }

  void hireEmployee(Business business, String name, double salary, Department department) {
    if (business.businessAccount != null && business.businessAccount!.balance >= salary) {
      business.hireEmployee(name, salary, department);
      print("Hired ${name} for business ${business.name}.");
    } else {
      print("Insufficient funds to hire ${name}.");
    }
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
