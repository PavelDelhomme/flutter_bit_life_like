import 'package:bit_life_like/Classes/ficalite/tax_system.dart';
import '../../screens/work/classes/business.dart';

class CorporateTaxDeclaration {
  final Business business;
  final TaxSystem taxSystem;
  double reportedIncome;
  double totalTaxesOwed = 0.0;
  bool isFraudulent = false;

  CorporateTaxDeclaration({
    required this.business,
    required this.taxSystem,
    required this.reportedIncome,
  });

  void calculateTaxes() {
    // Application des déductions avant le calcul des impôts
    applyAmortization();
    totalTaxesOwed = taxSystem.calculateCorporateTax(reportedIncome);
    print("Corporate Taxes Owed for ${business.name}: \$${totalTaxesOwed.toStringAsFixed(2)}");
  }

  void applyAmortization() {
    double amortizationDeduction = business.calculateAmortization();
    reportedIncome -= amortizationDeduction;
    print("Applied amortization deduction: \$${amortizationDeduction.toStringAsFixed(2)}");
  }

  void fileDeclaration() {
    if (isFraudulent) {
      print("Fraudulent tax filing detected for ${business.name}");
      // Peut-être générer une enquête fiscale aléatoire ici
    } else {
      print("${business.name} filed a corporate tax declaration with \$${totalTaxesOwed.toStringAsFixed(2)} in taxes owed.");
    }
  }

  void audit() {
    // Si une fraude est détectée pendant un audit
    if (isFraudulent) {
      print("Audit has uncovered tax fraud for ${business.name}. Penalties will be applied.");
      totalTaxesOwed += totalTaxesOwed * 0.5; // 50% de pénalité en cas de fraude
    } else {
      print("Audit completed: No issues found for ${business.name}");
    }
  }

  void markAsFraudulent() {
    isFraudulent = true;
    print("Marked ${business.name} tax declaration as fraudulent.");
  }
}
