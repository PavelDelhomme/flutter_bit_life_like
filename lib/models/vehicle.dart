import '../models/assets.dart';

class Vehicle extends Asset {
  String brand;
  String model;
  int productionYear;
  double mileage;

  Vehicle({
    required super.id,
    required super.ownerId,
    required this.brand,
    required this.model,
    required this.productionYear,
    this.mileage = 0.0,
    required super.name,
    required super.value,
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
  }) : super(
    type: AssetType.vehicle,
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