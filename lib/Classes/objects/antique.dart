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
    double parseValue(dynamic valeur) {
      if (valeur is num) {
        return valeur.toDouble();
      } else if (valeur is String) {
        // Try to parse the string as a double
        return double.tryParse(valeur) ?? 0.0; // Default to 0.0 if parsing fails
      }
      return 0.0; // Default value if it's not a number or parseable string
    }

    return Antique(
      name: json['nom'] as String,
      value: parseValue(json['valeur']),
      age: (json['age'] as num?)?.toInt() ?? 0,
      artist: json['artiste'] as String? ?? '',
      rarity: json['rarete'] as String? ?? 'Commun',
      epoch: json['epoque'] as String? ?? '',
    );
  }
}
