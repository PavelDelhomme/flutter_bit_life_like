abstract class Vehicle {
  String name;
  int age;
  double value;
  String type;
  String rarity;

  Vehicle({
    required this.name,
    required this.age,
    required this.value,
    required this.type,
    required this.rarity,
  });

  double getMonthlyMaintenanceCost();

  @override
  toString() {
    return '$name ($type) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Rarity: $rarity';
  }
}

class Moto extends Vehicle {
  Moto({
    required String name,
    required int age,
    required double value,
    required String rarity,
  }) : super(name: name, age: age, value: value, type: 'Moto', rarity: rarity);

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }
}

class Car extends Vehicle {
  Car({
    required String name,
    required int age,
    required double value,
    required String rarity,
  }) : super(name: name, age: age, value: value, type: 'Car', rarity: rarity);

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.015; // 1.5% of the value as maintenance cost
  }
}

class Boat extends Vehicle {
  Boat({
    required String name,
    required int age,
    required double value,
    required String rarity,
  }) : super(name: name, age: age, value: value, type: 'Boat', rarity: rarity);

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.02; // 2% of the value as maintenance cost
  }
}

class Airplane extends Vehicle {
  Airplane({
    required String name,
    required int age,
    required double value,
    required String rarity,
  }) : super(
            name: name,
            age: age,
            value: value,
            type: 'Airplane',
            rarity: rarity);

  @override
  double getMonthlyMaintenanceCost() {
    return value * 0.025; // 2.5% of the value as maintenance cost
  }
}
