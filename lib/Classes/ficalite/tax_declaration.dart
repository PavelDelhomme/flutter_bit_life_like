import 'package:bit_life_like/Classes/ficalite/tax_system.dart';
import 'package:bit_life_like/Classes/person.dart';

class TaxDeclaration {
  final Person person;
  final TaxSystem taxSystem;
  double reportedIncome;
  double reportedDeductions;
  double reportedCharityDonations;
  double reportedEucationExpenses;
  double totalTaxesOwed = 0.0;

  TaxDeclaration({
    required this.person,
    required this.taxSystem,
    required this.reportedIncome,
    this.reportedDeductions = 0.0,
    this.reportedCharityDonations = 0.0,
    this.reportedEucationExpenses = 0.0,
  });

  void calculateTaxes() {
    double taxableIncome = reportedIncome -
        reportedDeductions -
        reportedCharityDonations -
        reportedEucationExpenses;
    totalTaxesOwed = taxSystem
        .calculatePersonalTax(taxableIncome); // Utiliser calculatePersonalTax

    // Calculer la taxe sur la fortune si applicable
    double wealthTax = taxSystem.calculateWealthTax(person.calculateNetWorth());
    totalTaxesOwed += wealthTax;

    // Calculer la taxe sur les biens de luxe si applicable
    double luxuryTax = taxSystem.calculateLuxuryTax(person.collectibles);
    totalTaxesOwed += luxuryTax;

    print("Total Taxes Owed: \$${totalTaxesOwed.toStringAsFixed(2)}");
  }

  void fileDeclaration() {
    // Logique pour déclarer les impôts
    print(
        "${person.name} filed a tax declaration with \$${totalTaxesOwed.toStringAsFixed(2)} in taxes owed.");
  }

  void applyPenalties() {
    // Logique pour appliquer des pénalités en cas de retard ou de fraude
    print("${person.name} faces penalties for incorrect or late filing.");
  }
}
