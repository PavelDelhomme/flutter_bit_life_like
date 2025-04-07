import 'dart:math';

import 'package:bit_life_like/models/assets.dart';

class Arme extends Asset {
  String weaponType;
  int damage;

  Arme({
    required String id,
    required String ownerId,
    required this.weaponType,
    required this.damage,
    required String name,
    required double value,
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
  }) : super(
    id: id,
    ownerId: ownerId,
    type: AssetType.weapon,
    name: name,
    value: value,
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