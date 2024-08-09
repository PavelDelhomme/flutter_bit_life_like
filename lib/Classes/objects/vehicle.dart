import 'package:bit_life_like/services/bank/bank_account.dart';

abstract class Vehicle implements Purchasable {
  String name;
  int age;
  String type;
  String rarity;
  String? brand;
  double fuelConsumption;
  double monthlyFuelCost;

  @override
  final double value;

  Vehicle({
    required this.name,
    required this.age,
    required this.value,
    required this.type,
    required this.rarity,
    this.brand,
    required this.fuelConsumption,
    required this.monthlyFuelCost,
  });

  double getMonthlyMaintenanceCost();

  double calculateMonthlyFuelCost(double fuelPricePerLiter, double kilometersDrivenPerMonth) {
    if (fuelConsumption == 0) {
      return 0; // Electric vehicle
    }
    return (fuelConsumption / 100) * kilometersDrivenPerMonth * fuelPricePerLiter;
  }

  @override
  String toString() {
    return '$name ($type) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Rarity: $rarity, Brand: $brand';
  }
}


class Moto extends Vehicle {
  Moto({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
  }) : super(
    name: name,
    age: age,
    value: value,
    type: 'Moto',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );
  static Moto fromJson(Map<String, dynamic> json) {
    return Moto(
      name: json['name'] as String ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuel_consumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }
}
class Voiture extends Vehicle {
  Voiture({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
  }) : super(
    name: name,
    age: age,
    value: value,
    type: 'Car',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  static Voiture fromJson(Map<String, dynamic> json) {
    return Voiture(
      name: json['name'] as String? ?? 'Unknown',  // Assurez-vous que le champ 'name' est bien 'name' et pas 'nom'
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.015;
  }
}



class Bateau extends Vehicle {
  Bateau({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
  }) : super(
    name: name,
    age: age,
    value: value,
    type: 'Boat',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  static Bateau fromJson(Map<String, dynamic> json) {
    return Bateau(
      name: json['name'] ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.02; // 2% of the value as maintenance cost
  }
}


class Avion extends Vehicle {
  Avion({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
  }) : super(
    name: name,
    age: age,
    value: value,
    type: 'Airplane',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  static Avion fromJson(Map<String, dynamic> json) {
    return Avion(
      name: json['name'] ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.025; // 2.5% of the value as maintenance cost
  }
}
