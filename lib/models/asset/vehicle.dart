import 'assets.dart';

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
    value *= 0.95;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'brand': brand,
      'model': model,
      'productionYear': productionYear,
      'mileage': mileage,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      ownerId: json['ownerId'],
      brand: json['brand'],
      model: json['model'],
      productionYear: json['productionYear'],
      mileage: json['mileage'],
      name: json['name'],
      value: json['value'],
      condition: AssetCondition.values.firstWhere(
          (e) => e.toString() == json['condition'],
        orElse: () => AssetCondition.good,
      ),
      maintenanceCost: json['maintenanceCost'],
    );
  }
}