import 'package:bit_life_like/Classes/objects/collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

abstract class Vehicle extends CollectibleItem {
  final String name;
  final int age;
  final double value;
  final String type;
  final String rarity;
  final String? brand;
  final double fuelConsumption;
  final double monthlyFuelCost;

  Vehicle({
    required this.name,
    required this.age,
    required this.value,
    required this.type,
    required this.rarity,
    this.brand,
    required this.fuelConsumption,
    required this.monthlyFuelCost
  }) : super(
    name: name,
    value: value,
    rarity: rarity,
    epoch: 'N/A'
  );

  double getMonthlyMaintenanceCost();

  double calculateMonthlyFuelCost(
      double fuelPricePerLiter, double kilometersDrivenPerMonth) {
    if (fuelConsumption == 0) {
      return 0; // Electric vehicle
    }
    return (fuelConsumption / 100) *
        kilometersDrivenPerMonth *
        fuelPricePerLiter;
  }

  @override
  String toString() {
    return '$name ($type) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Rarity: $rarity, Brand: $brand';
  }

  String? getRequiredPermit() {
    switch (type.toLowerCase()) {
      case 'car':
        return 'car';
      case 'motorcycle':
        return 'motorcycle';
      case 'boat':
        return 'boat';
      case 'airplane':
        return 'airplane';
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'type': type,
      'rarity': rarity,
      'brand': brand,
      'fuelConsumption': fuelConsumption,
      'monthlyFuelCost': monthlyFuelCost,
      'value': value,
    };
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
    type: 'Motorcycle',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  static Moto fromJson(Map<String, dynamic> json) {
    return Moto(
      name: json['name'] as String? ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }

  @override
  String display() {
    // TODO: implement display
    throw UnimplementedError();
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
      name: json['name'] as String? ?? 'Unknown',
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

  @override
  String display() {
    // TODO: implement display
    throw UnimplementedError();
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

  @override
  String display() {
    // TODO: implement display
    throw UnimplementedError();
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

  @override
  String display() {
    // TODO: implement display
    throw UnimplementedError();
  }
}
