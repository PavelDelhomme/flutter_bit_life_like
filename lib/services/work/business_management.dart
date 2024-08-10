
import 'package:bit_life_like/Classes/person.dart';

class BusinessManagementService {
  void startBusiness(Person person, String name, String type, double investment) {
    if (person.bankAccounts.isNotEmpty && person.bankAccounts.first.balance >= investment) {
      person.startBusiness(name, type, investment);
      print("${person.name} has started a new business: ${name} with ${investment}\$.");
    } else {
      print("Insufficient funds to start a new business.");
    }
  }

  void manageBusiness(Person person) {
    person.businesses.forEach(
            (business) {
              // Simulate business activities
              business.payExpenses(500);
              print("Business : ${business.name}, Balance : ${business.balance}");
            }
    );
  }
}