import 'dart:math';

import '../models/assets.dart';

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
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
  }) : super(
    type: AssetType.weapon,
    age: age,
    condition: condition,
    maintenanceCost: maintenanceCost,
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
}