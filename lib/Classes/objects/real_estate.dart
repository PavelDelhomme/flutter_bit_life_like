import 'package:bit_life_like/Classes/person.dart';

class RealEstate {
  String name;
  int age;
  double value;
  String type;
  String condition; // e.g, 'New', 'Good', 'Needs Renovation' // devrai être iun pourcentage car il y aur un pourcentage de dégradation annuel pour chaque type de bien d'ailleurs
  double monthlyMaintenanceCost;
  bool estLouee;
  Person? locataire;

  RealEstate({
    required this.name,
    required this.age,
    required this.value,
    required this.type,
    required this.condition,
    required this.monthlyMaintenanceCost,
    required this.estLouee,
    this.locataire,
  });

  @override
  String toString() {
    return '$name ($type) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Condition: $condition, Monthly Maintenance Cost: \$${monthlyMaintenanceCost.toStringAsFixed(2)}';
  }

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      name: json['nom'],
      age: json['age'],
      value: json['valeur'],
      type: json['type'],
      condition: json['condition'],
      monthlyMaintenanceCost: json['monthly_maintenance_cost'],
      estLouee: json['estLouee'],
    );
  }
}