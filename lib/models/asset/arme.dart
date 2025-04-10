import 'dart:math';

import 'assets.dart';

class Arme extends Asset {
  String weaponType;
  int damage;

  Arme({
    required super.id,
    required super.ownerId,
    required this.weaponType,
    required this.damage,
    required super.name,
    required super.value,
    super.age,
    super.condition,
    super.maintenanceCost,
  }) : super(
    type: AssetType.weapon,
    depreciationRate: 0.1,
  );

  @override
  void deteriorate() {
    // Dégradation accélérée pour les armes
    if (Random().nextDouble() < 0.2) {
      int index = AssetCondition.values.indexOf(condition);
      condition = AssetCondition.values[min(AssetCondition.values.length - 1, index + 1)];
    }
    value *= 0.9;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'weaponType': weaponType,
      'damage': damage,
    };
  }

  factory Arme.fromJson(Map<String, dynamic> json) {
    return Arme(
      id: json['id'],
      ownerId: json['ownerId'],
      weaponType: json['weaponType'],
      damage: json['damage'],
      name: json['name'],
      value: json['value'],
      age: json['age'],
      condition: AssetCondition.values.firstWhere(
            (e) => e.toString() == json['condition'],
        orElse: () => AssetCondition.good,
      ),
      maintenanceCost: json['maintenanceCost'],
    );
  }
}