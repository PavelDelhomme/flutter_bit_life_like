import 'dart:js_interop';

import 'package:bit_life_like/Classes/life_history_event.dart';

import '../../Classes/person.dart';
import '../../screens/work/classes/business.dart';
import '../bank/bank_account.dart';

class BusinessManagementService {
  void startBusiness(Person person, String name, String type, double investment, BankAccount businessAccount) {
    if (person.realEstates.isNotEmpty && businessAccount.balance >= investment) {
      var business = Business(name: name, type: type, initialInvestment: investment, businessAccount: businessAccount);
      person.businesses.add(business);  // Person peut avoir une liste de businesses
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "${person.name} started a new business: $name.",
        timestamp: DateTime.now(),
        ageAtEvent: person.age,
        personId: person.id
      ));
      businessAccount.withdraw(investment);
      print("${person.name} a créé un nouveau business: ${name} avec un investissement de \$${investment}.");
    } else {
      print("Fonds ou propriété immobilière insuffisants pour démarrer une entreprise.");
    }
  }

  void addProductToBusiness(Business business, Product product, Person person) {
    business.addProduct(product.name);
    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "${person.name} added product ${product.name} to business ${business.name}.",
      timestamp: DateTime.now(),
      ageAtEvent: person.age,
      personId: person.id
    ));
    print("Ajouté le produit ${product.name} au business ${business.name}.");
  }

  void hireEmployee(Business business, String name, double salary, Department department, Person person) {
    if (business.businessAccount != null && business.businessAccount!.balance >= salary) {
      business.hireEmployee(name, salary, department);
      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "${person.name} added employee ${name} for business ${business.name}.",
        timestamp: DateTime.now(),
        personId: person.id, ageAtEvent: person.age,
      ));
      print("${name} embauché dans le business ${business.name}.");
    } else {
      print("Fonds insuffisants pour embaucher ${name}.");
    }
  }

  void handleTaxes(Business business, Person person) {
    double taxes = business.calculateTax();
    business.payTaxes();
    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "${person.name}'s business ${business.name} paid \$${taxes} in taxes.",
      timestamp: DateTime.now(),
      ageAtEvent: person.age,
      personId: person.id,  // Ajout de l'identifiant de la personne
    ));
    print("Taxes payées pour ${business.name}: \$${taxes}");
  }

  void calculateExpenses(Business business, Person person) {
    double employeeExpenses = business.employees.fold(0, (sum, e) => sum + e.salary);
    business.payExpenses(employeeExpenses);
    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "${person.name}'s business ${business.name} paid \$${employeeExpenses} in employee expenses.",
      timestamp: DateTime.now(),
      ageAtEvent: person.age,
      personId: person.id,  // Ajout de l'identifiant de la personne
    ));
    print("Frais de personnel payés pour ${business.name}");
  }
}
