import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
class RealEstate implements Purchasable {
  String name;
  int age;
  String type;
  double condition;
  double monthlyMaintenanceCost;
  bool estLouee;
  String style;
  Person? locataire;
  bool isExotic;
  final double _value;
  int? capacity;

  RealEstate({
    required this.name,
    required this.age,
    required double value,
    required this.type,
    required this.condition,
    required this.monthlyMaintenanceCost,
    required this.estLouee,
    this.style = 'Classic',
    this.locataire,
    this.isExotic = false,
    required this.capacity,
  }) : _value = value;

  @override
  double get value => _value;

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      name: json['nom'] ?? 'Nom inconnu',
      age: json['age'] ?? 0,
      value: (json['valeur'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'Type inconnu',
      condition: (json['condition'] as num?)?.toDouble() ?? 100.0,
      monthlyMaintenanceCost: (json['monthly_maintenance_cost'] as num?)?.toDouble() ?? 0.0,
      estLouee: json['estLouee'] as bool? ?? false,
      style: json['style'] ?? 'Classic', // Assurez-vous que 'style' est bien passé
      isExotic: json.containsKey('isExotic') && json['isExotic'],
      locataire: json['locataire'] != null ? Person.fromJson(json['locataire'] as Map<String, dynamic>) : null,
      capacity: json['capacity'] ?? 10, // Default capacity
    );
  }

  void degradeCondition(double percentage) {
    condition -= percentage;
    if (condition < 0) condition = 0;
  }

  @override
  String toString() {
    return '$name ($type, $style) - Age: $age, Value: \$${value.toStringAsFixed(2)}, Condition: $condition, Monthly Maintenance Cost: \$${monthlyMaintenanceCost.toStringAsFixed(2)}';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'type': type,
      'condition': condition,
      'monthlyMaintenanceCost': monthlyMaintenanceCost,
      'estLouee': estLouee,
      'style': style,
      'locataire': locataire?.toJson(),
      'isExotic': isExotic,
      'value': _value,
      'capacity': capacity,
    };
  }
}
