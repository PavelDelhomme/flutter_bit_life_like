
import '../../services/bank/bank_account.dart';

class Antique implements Purchasable {
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
      value: (json['valeur'] as num?)?.toDouble() ?? 0.0,
      age: (json['age'] as num?)?.toInt() ?? 0,
      artist: json['artiste'] as String? ?? '',
      rarity: json['rarete'] as String? ?? 'Commun',
      epoch: json['epoque'] as String? ?? '',
    );
  }
}