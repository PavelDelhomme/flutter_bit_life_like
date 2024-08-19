class Bateau {
  final String name;
  final int age;
  final double value;
  final String rarity;
  final String? brand;
  final double fuelConsumption;
  final double monthlyFuelCost;

  Bateau({
    required this.name,
    required this.age,
    required this.value,
    required this.rarity,
    this.brand,
    required this.fuelConsumption,
    required this.monthlyFuelCost,
  });

  double getMonthlyMaintenanceCost() {
    return value * 0.02; // 2% of the value as maintenance cost
  }

  double calculateMonthlyFuelCost(double fuelPricePerLiter, double kilometersDrivenPerMonth) {
    if (fuelConsumption == 0) return 0; // Electric vehicle
    return (fuelConsumption / 100) * kilometersDrivenPerMonth * fuelPricePerLiter;
  }

  String display() {
    return '$name (Bateau) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Rarity: $rarity, Brand: $brand';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'value': value,
      'rarity': rarity,
      'brand': brand,
      'fuelConsumption': fuelConsumption,
      'monthlyFuelCost': monthlyFuelCost,
    };
  }

  static Bateau fromJson(Map<String, dynamic> json) {
    return Bateau(
      name: json['name'] ?? 'Unknown',
      age: json['age'] ?? 0,
      value: json['value'] ?? 0.0,
      rarity: json['rarity'] ?? 'Unknown',
      brand: json['brand'],
      fuelConsumption: json['fuelConsumption'] ?? 0.0,
      monthlyFuelCost: json['monthlyFuelCost'] ?? 0.0,
    );
  }
}
