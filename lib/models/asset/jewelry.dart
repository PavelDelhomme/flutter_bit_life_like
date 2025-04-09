import 'assets.dart';

class Jewelry extends Asset {
  String material;
  double carat;

  Jewelry({
    required String id,
    required String ownerId,
    required this.material,
    required this.carat,
    required String name,
    required double value,
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
  }) : super(
    id: id,
    ownerId: ownerId,
    type: AssetType.jewelry,
    name: name,
    value: value,
    age: age,
    condition: condition,
    maintenanceCost: maintenanceCost,
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
