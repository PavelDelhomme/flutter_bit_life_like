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

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      name: json['nom'] as String,
      age: json['age'] as int,
      value: (json['valeur'] as num).toDouble(),
      type: json['type'] as String,
      condition: json['condition'] as String,
      monthlyMaintenanceCost: (json['monthly_maintenance_cost'] as num).toDouble(),
      estLouee: json['estLouee'] as bool? ?? false,
      locataire: json['locataire'] != null ? Person.fromJson(json['locataire'] as Map<String, dynamic>) : null,
    );
  }


  @override
  String toString() {
    return '$name ($type) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Condition: $condition, Monthly Maintenance Cost: \$${monthlyMaintenanceCost.toStringAsFixed(2)}';
  }
}