import 'vehicle.dart';

class VehiculeExotique extends Vehicle {
  VehiculeExotique({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
    required int monthlyFuelCost,
  }) : super(
    name: name,
    age: age,
    value: value,
    type: 'Exotic',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.03; // 3% of the value as maintenance cost
  }
}

class VoitureDeCollection extends Vehicle {
  VoitureDeCollection({
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
    type: 'Collection Voiture',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }
}

class MotoDeCollection extends Vehicle {
  MotoDeCollection({
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
    type: 'Collection Moto',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }
}

class BateauDeCollection extends Vehicle {
  BateauDeCollection({
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
    type: 'Collection Bateau',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.02; // 2% of the value as maintenance cost
  }
}

class AvionDeCollection extends Vehicle {
  AvionDeCollection({
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
    type: 'Collection Avion',
    rarity: rarity,
    brand: brand,
    fuelConsumption: fuelConsumption,
    monthlyFuelCost: 0,
  );

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.025; // 2.5% of the value as maintenance cost
  }
}
