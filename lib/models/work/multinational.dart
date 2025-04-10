import 'business.dart';

class Multinational {
  final String id;
  Map<String, Business> subsidiaries;
  Map<String, double> marketShares;

  Multinational({
    required this.id,
    required this.subsidiaries,
    required this.marketShares,
  });

  double calculateGlobalRevenue() {
    return subsidiaries.values.fold(0.0, (sum, biz) => sum + biz.valuation * 0.1);
  }
}
