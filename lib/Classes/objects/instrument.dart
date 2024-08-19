import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Instrument {
  final String type; // Par exemple: Cordes, Percussion, Vent, etc.

  Instrument({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
    required this.type,
  });

  get name => this.name;
  get value => this.value;
  get epoch => this.epoch;
  get rarity => this.rarity;

  String display() {
    return "$name ($type) - Epoch: ${epoch}, Value: \$${value}, Rarity: ${rarity}";
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'rarity': rarity,
      'epoch': epoch,
      'type': type,
    };
  }

  static Instrument fromJson(Map<String, dynamic> json) {
    return Instrument(
      name: json['name'] as String? ?? 'Unknown',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rarity: json['rarity'] as String? ?? 'Unknown',
      epoch: json['epoch'] as String? ?? 'Unknown',
      type: json['type'] as String? ?? 'Unknown',
    );
  }
}
