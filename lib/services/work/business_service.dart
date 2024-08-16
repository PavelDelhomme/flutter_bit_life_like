import 'package:bit_life_like/screens/work/classes/business.dart';

class BusinessService {
  void manageBusiness(Business business) {
    business.generateIncome();// required amount value
    business.paySalaries();
    business.applyAmortization();
    business.handleAudit();
    business.payTaxes();
    business.calculateAnnualProfit();

    print("${business.name}'s annual operation completed.");
  }
}