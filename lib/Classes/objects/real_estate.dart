import 'package:bit_life_like/Classes/person.dart';

class RealEstate {
  String name;
  int age;
  double value;
  String type;
  String condition; // e.g, 'New', 'Good', 'Needs Renovation' // devrai être iun pourcentage car il y aur un pourcentage de dégradation annuel pour chaque type de bien d'ailleurs
  double monthlyMaintenanceCost;
  bool estLouee;
  String style;
  Person? locataire;
  bool isExotic;

  RealEstate({
    required this.name,
    required this.age,
    required this.value,
    required this.type,
    required this.condition,
    required this.monthlyMaintenanceCost,
    required this.estLouee,
    this.style = 'Classic',
    this.locataire,
    this.isExotic = false,
  });

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      name: json['nom'] ?? 'Nom inconnu',
      age: json['age'] ?? 0,
      value: (json['valeur'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'Type inconnu',
      condition: json['condition'] ?? 'Condition inconnue',
      monthlyMaintenanceCost: (json['monthly_maintenance_cost'] as num?)?.toDouble() ?? 0.0,
      estLouee: json['estLouee'] as bool? ?? false,
      style: json['style'] ?? 'Classic', // Assurez-vous que 'style' est bien passé
      isExotic: json.containsKey('isExotic') && json['isExotic'],
      locataire: json['locataire'] != null ? Person.fromJson(json['locataire'] as Map<String, dynamic>) : null,
    );
  }


  @override
  String toString() {
    return '$name ($type, $style) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Condition: $condition, Monthly Maintenance Cost: \$${monthlyMaintenanceCost.toStringAsFixed(2)}';
  }
}