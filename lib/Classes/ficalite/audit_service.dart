import 'package:bit_life_like/Classes/ficalite/tax_system.dart';

import '../person.dart';
import 'fraud_detection.dart';

class AuditService {
  final TaxSystem taxSystem;
  final FraudDetectionService fraudDetectionService;

  AuditService(this.taxSystem, this.fraudDetectionService);

  void audit(Person person) {
    bool foundFraud = fraudDetectionService.detectFraud(person);
    if (foundFraud) {
      double fine = person.calculateAnnualIncome() * 0.3;
      person.bankAccounts.first.withdraw(fine);
      print("Fraud detected. Fine applied: \$${fine.toStringAsFixed(2)}");
    } else {
      print("Audit completed. No fraud detected.");
    }
  }
}
