import 'assets.dart';

class Electronic extends Asset {
  final String id;
  final String ownerId;
  final String name;
  final double value;
  final int age;
  final AssetCondition condition;
  final double maintenanceCost;
  final bool supportApplications;
  final String brand;
  final String typeElectronic; // smartphone, laptop, server, ...

  Electronic({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.value,
    required this.age,
    required this.condition,
    required this.maintenanceCost,
    this.supportApplications = false,
    required this.brand,
    required this.typeElectronic
  }) : super(
    id: id,
    ownerId: ownerId,
    name: name,
    value: value,
    type: AssetType.electronic,
    appreciationRate: 0.05,
  );

  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      ownerId: json['ownerId'],
      name: json['name'],
      value: json['value'],
      age: json['age'],
      condition: json['condition'],
      maintenanceCost: json['maintenanceCost'],
      supportApplications: json['supportApplications'],
      brand: json['brand'],
      typeElectronic: json['tpeElectronic'],
    );
  }

}
