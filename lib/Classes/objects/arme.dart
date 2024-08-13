import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Arme extends CollectibleItem {
  final String type;
  final int damage;  // Dégâts potentiels de l'arme
  final double lethality;  // Probabilité de tuer

  Arme({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
    required this.type,
    required this.damage,
    required this.lethality,
  }) : super(
    name: name,
    value: value,
    rarity: rarity,
    epoch: epoch,
  );

  @override
  String display() {
    return "$name ($type) - Epoch: $epoch, Value: \$$value, Rarity: $rarity, Damage: $damage, Lethality: ${lethality * 100}%";
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'rarity': rarity,
      'epoch': epoch,
      'type': type,
      'damage': damage,
      'lethality': lethality,
    };
  }

  static Arme fromJson(Map<String, dynamic> json) {
    return Arme(
      name: json['name'] as String? ?? 'Unknown',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      epoch: json['epoch'] as String? ?? 'Unknown',
      type: json['type'] as String? ?? 'Unknown',
      damage: (json['damage'] as num?)?.toInt() ?? 0,
      lethality: (json['lethality'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
