import 'dart:math';
import 'package:bit_life_like/Classes/ficalite/audit_service.dart';
import 'package:bit_life_like/Classes/ficalite/fraud_detection.dart';
import 'package:bit_life_like/Classes/ficalite/tax_system.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/Classes/event.dart';
import 'package:bit_life_like/services/events/events_decision/event_service.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';

import '../../bank/fiscal_control_service.dart';

class YearlyUpdateService {
  final Random random = Random();
  final AuditService auditService = AuditService(TaxSystem(), FraudDetectionService());

  void processYearlyUpdate(Person person) {
    person.ageOneYear();
    person.manageFinances();

    for (var business in person.businesses) {
      business.processAnnualUpdate();
    }

    FinancialService.applyAnnualInflation();

    if (random.nextDouble() < 0.1) {
      auditService.audit(person);
    }

    if (random.nextDouble() < 0.1) {
      FiscalControlService().performFiscalControl(person);
    }

    EventService eventService = EventService(events: []);
    Event? randomEvent = eventService.generateRandomEvent(person);
    if (randomEvent != null) {
      eventService.triggerEvent(person, randomEvent);
    }

    print("Yearly update processed for ${person.name}. Age: ${person.age}");
  }
}
