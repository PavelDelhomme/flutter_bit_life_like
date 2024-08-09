import 'package:bit_life_like/services/bank/bank_account.dart';

class Antique extends Purchasable {
  final String name;
  final int age;
  final String dates;
  final String artiste;
  final double value; // Change to double for consistency

  Antique({
    required this.name,
    required this.age,
    required this.dates,
    required this.artiste,
    required this.value, // Use `value` for consistency
  });

  factory Antique.fromJson(Map<String, dynamic> json) {
    return Antique(
      name: json['nom'],
      age: json['age'],
      dates: json['dates'],
      artiste: json['artiste'],
      value: (json['valeur'] as num).toDouble(), // Ensure correct type
    );
  }

  @override
  String display() {
    return 'Antique: $name, Dates: $dates, Value: \$${value.toString()}, Artist: $artiste';
  }
}
