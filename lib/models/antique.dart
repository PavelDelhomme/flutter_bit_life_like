import 'dart:math';

import 'package:bit_life_like/models/assets.dart';

class Antique extends Asset {
  int yearOfOrigin;
  String era;
  String? artist;
  bool isAuthenticated;
  double rarity;

  Antique({
    required String id,
    required String ownerId,
    required this.yearOfOrigin,
    required this.era,
    this.artist,
    this.isAuthenticated = false,
    this.rarity = 0.5,
    required String name,
    required double value,
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
  }) : super(
    id: id,
    ownerId: ownerId,
    type: AssetType.antique,
    name: name,
    value: value,
    age: age,
    condition: condition,
    maintenanceCost: maintenanceCost,
    depreciationRate: 0.01,
    appreciationRate: 0.05,
  );

  void authenticate() {
    if (!isAuthenticated) {
      isAuthenticated = true;
      value *= (rarity > 0.7) ? 2.0 : 1.5;
    }
  }

  @override
  void deteriorate() {
    if (Random().nextDouble() < 0.05) {
      int index = AssetCondition.values.indexOf(condition);
      if (index < AssetCondition.values.length - 1) {
        condition = AssetCondition.values[index + 1];
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'yearOfOrigin': yearOfOrigin,
      'era': era,
      'artist': artist,
      'isAuthenticated': isAuthenticated,
      'rarity': rarity,
    };
  }
  
  factory Antique.fromJson(Map<String, dynamic> json) {
    return Antique(
      id: json['id'],
      ownerId: json['ownerId'],
      yearOfOrigin: json['yearOfOrigin'],
      era: json['era'],
      artist: json['artist'],
      isAuthenticated: json['isAuthenticated'],
      rarity: json['rarity'],
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