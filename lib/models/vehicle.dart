import 'package:bit_life_like/models/assets.dart';

class Vehicle extends Asset {
  String brand;
  String model;
  int productionYear;
  double mileage;

  Vehicle({
    required String id,
    required String ownerId,
    required this.brand,
    required this.model,
    required this.productionYear,
    this.mileage = 0.0,
    required String name,
    required double value,
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
  }) : super(
    id: id,
    ownerId: ownerId,
    type: AssetType.vehicle,
    name: name,
    value: value,
    age: age,
    condition: condition,
    maintenanceCost: maintenanceCost,
    depreciationRate: 0.15,
  );

  
  @override
  void deteriorate() {
    super.deteriorate();
    // Détérioration supplémentaire pour les véhicules
    value *= 0.95;
  }
}