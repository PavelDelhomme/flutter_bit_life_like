import 'package:bitlife_like/models/inventory_item.dart';
import 'assets.dart';

class Electronic extends Asset implements InventoryItem {
  final bool supportApplications;
  final String brand;
  final String typeElectronic;

  Electronic({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.value,
    super.age = 0,
    super.condition = AssetCondition.good,
    super.maintenanceCost = 0.0,
    this.supportApplications = false,
    required this.brand,
    required this.typeElectronic,
  }) : super(type: AssetType.electronic, appreciationRate: 0.05);

  @override
  Map<String, double> get skillEffects => {};



  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      ownerId: json['ownerId'],
      name: json['name'],
      value: json['value'],
      age: json['age'],
      condition: AssetCondition.values.firstWhere(
            (e) => e.toString() == json['condition'],
        orElse: () => AssetCondition.good,
      ),
      maintenanceCost: json['maintenanceCost'],
      supportApplications: json['supportApplications'] ?? false,
      brand: json['brand'],
      typeElectronic: json['typeElectronic'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'supportApplications': supportApplications,
      'brand': brand,
      'typeElectronic': typeElectronic,
    };
  }

}
