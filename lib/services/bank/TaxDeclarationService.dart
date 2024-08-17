import 'package:bit_life_like/Classes/person.dart';

import '../../Classes/ficalite/tax_system.dart';

class TaxDeclarationService {
  static double calculateTaxes(Person person) {
    if (person.age < 16) {
      return 0.0;
    }
    TaxSystem taxSystem = TaxSystem();
    double annualIncome = person.calculateAnnualIncome();
    return taxSystem.calculatePersonalTax(annualIncome);
  }
}
