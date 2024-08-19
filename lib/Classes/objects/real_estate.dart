import 'package:bit_life_like/Classes/objects/collectible_item.dart';
import 'package:bit_life_like/Classes/person.dart';

class RealEstate {
  final String name;
  final double value;
  final int age;
  final String type;
  double condition;
  final double monthlyMaintenanceCost;
  late final bool estLouee;
  final String style;
  final Person? locataire;
  final bool isExotic;
  final int? capacity;

  RealEstate({
    required this.name,
    required this.value,
    required this.age,
    required this.type,
    required this.condition,
    required this.monthlyMaintenanceCost,
    required this.estLouee,
    this.style = 'Classic',
    this.locataire,
    this.isExotic = false,
    this.capacity = 10,
  });

  String display() {
    return '${this.name} ($type, $style) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Condition: $condition, Monthly Maintenance Cost: \$${monthlyMaintenanceCost.toStringAsFixed(2)}';
  }

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      name: json['nom'] as String? ?? 'Unknown',  // Gérer null pour name
      value: (json['valeur'] as num?)?.toDouble() ?? 0.0,
      age: (json['age'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'Unknown',  // Gérer null pour type
      condition: (json['condition'] as num?)?.toDouble() ?? 100.0,
      monthlyMaintenanceCost:
      (json['monthlyMaintenanceCost'] as num?)?.toDouble() ?? 0.0,
      estLouee: json['estLouee'] as bool? ?? false,
      style: json['style'] as String? ?? 'Classic',  // Gérer null pour style
      locataire: json['locataire'] != null
          ? Person.fromJson(json['locataire'] as Map<String, dynamic>)
          : null,
      capacity: json['capacity'] as int? ?? 10,
    );
  }


  void degradeCondition(double percentage) {
    condition -= percentage;
    if (condition < 0) condition = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'age': age,
      'type': type,
      'condition': condition,
      'monthlyMaintenanceCost': monthlyMaintenanceCost,
      'estLouee': estLouee,
      'style': style,
      'locataire': locataire?.toJson(),
      'isExotic': isExotic,
      'capacity': capacity,
    };
  }
}
