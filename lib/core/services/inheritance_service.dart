import 'dart:math';
import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/shared/tax_system.dart';
import 'package:bitlife_like/core/shared/legal.dart';

class InheritanceService {
  static Character processInheritance({
    required Character deceased,
    required Character heir,
    bool autoDeclare = true,
    bool simulatedFraud = false,
    double? customDeclaredAmount,
  }) {
    final taxSystem = deceased.legalSystem?.taxSystem ?? TaxSystem(country: deceased.country);
    final auditProbability = deceased.legalSystem?.auditProbability ?? 0.05;
    //final inheritanceTaxRate = deceased.legalSystem?.inheritanceTaxRate ?? 0.3;

    final totalHeritage = deceased.money;
    final taxAmount = taxSystem.calculateInheritanceTax(totalHeritage);
    final amountAfterTax = totalHeritage - taxAmount;

    double declaredAmount;

    if (autoDeclare) {
      declaredAmount = totalHeritage;
    } else if (simulatedFraud) {
      declaredAmount = customDeclaredAmount ?? totalHeritage * (0.7 + (0.2 * (Random().nextDouble())));
    } else {
      declaredAmount = 0;
    }

    final discrepancy = totalHeritage - declaredAmount;
    final discrepancyRate = discrepancy / totalHeritage;
    final bool audited = Random().nextDouble() < (auditProbability + discrepancyRate * 0.4);

    if (audited && discrepancyRate > 0.1) {
      final fine = discrepancy * 1.5;
      deceased.withdraw(fine);

      final crime = Crime(
        id: 'crime_${DateTime.now().millisecondsSinceEpoch}',
        type: CrimeType.taxEvasion,
        date: DateTime.now(),
        description: "Fraude fiscale détectée lors du transfert d'héritage.",
        punishment: PunishmentType.fine,
        fine: fine,
        isSolved: true,
      );
      deceased.criminalHistory.add(crime);

      deceased.addLifeEvent("Contrôle fiscal post-mortem : amende de \$${fine.toStringAsFixed(2)}");
      heir.addLifeEvent("Héritage reçu après fraude détectée (\$${discrepancy.toStringAsFixed(2)})");
    }

    // Argent
    heir.deposit(amountAfterTax);
    deceased.withdraw(totalHeritage);

    // Propriétés et biens
    for (var prop in deceased.properties) {
      prop.transfertOwnership(deceased, heir);
      heir.properties.add(prop);
    }

    for (var asset in deceased.assets) {
      asset.transferOwnership(heir.id);
      heir.assets.add(asset);
    }

    // Entreprises
    for (var biz in deceased.businesses) {
      heir.businesses.add(biz);
    }

    heir.addLifeEvent("J'ai hérité de \$${amountAfterTax.toStringAsFixed(2)} de ${deceased.fullName}");
    deceased.addLifeEvent("Je suis décédé(e) et mon héritage est allé à ${heir.fullName}");

    deceased.isPNJ = true;

    return heir;
  }
}