import 'assets.dart';

class Jewelry extends Asset {
  String material;
  double carat;

  Jewelry({
    required super.id,
    required super.ownerId,
    required this.material,
    required this.carat,
    required super.name,
    required super.value,
    super.age,
    super.condition,
    super.maintenanceCost,
  }) : super(
    type: AssetType.jewelry,
    appreciationRate: 0.05,
  );


  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'material': material,
      'carat': carat,
    };
  }

  factory Jewelry.fromJson(Map<String, dynamic> json) {
    return Jewelry(
      id: json['id'],
      ownerId: json['ownerId'],
      material: json['material'],
      carat: json['carat'],
      name: json['name'],
      value: json['value'],
      age: json['age'],
      condition: AssetCondition.values.firstWhere(
            (e) => e.toString() == json['condition'],
        orElse: () => AssetCondition.good,
      ),
      maintenanceCost: json['maintenanceCost'],
    );
  }
}
