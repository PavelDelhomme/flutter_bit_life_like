class VoitureDeCollection {
  VoitureDeCollection({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
    required double monthlyFuelCost,
  });

  get value => this.value;

  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }

  static VoitureDeCollection fromJson(Map<String, dynamic> json) {
    return VoitureDeCollection(
      name: json['name'] as String? ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
      monthlyFuelCost: (json['monthlyFuelCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String display() {
    // TODO: implement display
    throw UnimplementedError();
  }
}

class MotoDeCollection {
  MotoDeCollection({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
    required double monthlyFuelCost,
  });

  get value => this.value;

  double getMonthlyMaintenanceCost() {
    return value * 0.01; // 1% of the value as maintenance cost
  }

  static MotoDeCollection fromJson(Map<String, dynamic> json) {
    return MotoDeCollection(
      name: json['name'] as String? ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
      monthlyFuelCost: (json['monthlyFuelCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String display() {
    // TODO: implement display
    throw UnimplementedError();
  }
}

class BateauDeCollection {
  BateauDeCollection({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
    required double monthlyFuelCost,
  });

  get value => value;

  double getMonthlyMaintenanceCost() {
    return value * 0.02; // 2% of the value as maintenance cost
  }

  static BateauDeCollection fromJson(Map<String, dynamic> json) {
    return BateauDeCollection(
      name: json['name'] as String? ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
      monthlyFuelCost: (json['monthlyFuelCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String display() {
    // TODO: implement display
    throw UnimplementedError();
  }
}

class AvionDeCollection {
  AvionDeCollection({
    required String name,
    required int age,
    required double value,
    required String rarity,
    String? brand,
    required double fuelConsumption,
    required double monthlyFuelCost,
  });

  get value => this.value;

  double getMonthlyMaintenanceCost() {
    return value * 0.025; // 2.5% of the value as maintenance cost
  }

  static AvionDeCollection fromJson(Map<String, dynamic> json) {
    return AvionDeCollection(
      name: json['name'] as String? ?? 'Unknown',
      age: (json['age'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      fuelConsumption: (json['fuelConsumption'] as num?)?.toDouble() ?? 0.0,
      monthlyFuelCost: (json['monthlyFuelCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String display() {
    // TODO: implement display
    throw UnimplementedError();
  }
}
