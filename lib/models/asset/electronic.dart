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
  final String type; // smartphone, laptop, server, ...

  Electronic({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.value,
    super.age,
    super.condition,
    super.maintenanceCost,
    this.supportApplications = false,
  }) : super(
    type: AssetType.electronic,
    appreciationRate: 0.05,
  );

  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      ownerId: json['ownerId'],
      name: json['name'],
      
    )
  }

}
