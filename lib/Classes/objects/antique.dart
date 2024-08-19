import 'package:bit_life_like/Classes/objects/collectible_item.dart';

import '../../services/bank/bank_account.dart';

class Antique {
  final String name;
  final double value;
  final int age;
  final String artist;
  final String rarity;
  final String epoch;

  Antique({
    required this.name,
    required this.value,
    required this.age,
    required this.artist,
    required this.rarity,
    required this.epoch,
  });

  factory Antique.fromJson(Map<String, dynamic> json) {
    return Antique(
      name: json['nom'] as String,
      value: (json['valeur'] as num).toDouble(),
      age: (json['age'] as num?)?.toInt() ?? 0,
      artist: json['artiste'] as String? ?? '',
      rarity: json['rarete'] as String? ?? 'Commun',
      epoch: json['epoque'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': name,
      'valeur': value,
      'age': age,
      'artiste': artist,
      'rarete': rarity,
      'epoque': epoch,
    };
  }

  String display() {
    // TODO: implement display
    throw UnimplementedError();
  }
}
