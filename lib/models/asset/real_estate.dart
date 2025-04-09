import 'dart:math';
import 'assets.dart';

class RealEstate extends Asset {
  String location;
  double squareMeters;
  int rooms;
  bool isRented;
  double monthlyRent;
  String? tenantId;
  double propertyTaxRate;
  
  RealEstate({
    required String id,
    required String ownerId,
    required this.location,
    required this.squareMeters,
    required this.rooms,
    this.isRented = false,
    this.monthlyRent = 0.0,
    this.tenantId,
    this.propertyTaxRate = 0.01,
    required String name,
    required double value,
    int age = 0,
    AssetCondition condition = AssetCondition.good,
    double maintenanceCost = 0.0,
    bool isInsured = false,
    double insuranceCost = 0.0,
  }) : super(
    id: id,
    ownerId: ownerId,
    type: AssetType.realEstate,
    name: name,
    value: value,
    age: age,
    condition: condition,
    maintenanceCost: maintenanceCost,
    isInsured: isInsured,
    insuranceCost: insuranceCost,
    monthlyIncome: isRented ? monthlyRent : 0.0,
    depreciationRate: 0.02, // Les propriétés immobilières se déprécient moins
    appreciationRate: 0.03, // Les propriétés immobilières peuvent prendre de la valeur
  );
  
  double calculateMonthlyProfit() {
    if (!isRented) return -maintenanceCost;
    return monthlyRent - maintenanceCost - (value * propertyTaxRate / 12);
  }
  
  void rentOut(String newTenantId, double rent) {
    isRented = true;
    tenantId = newTenantId;
    monthlyRent = rent;
    monthlyIncome = rent;
  }
  
  void evictTenant() {
    isRented = false;
    tenantId = null;
    monthlyRent = 0.0;
    monthlyIncome = 0.0;
  }
  
  void transfertOwnership(dynamic from, dynamic to) {
    // Logique de transfert de propriété
    ownerId = to.id;
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'location': location,
      'squareMeters': squareMeters,
      'rooms': rooms,
      'isRented': isRented,
      'monthlyRent': monthlyRent,
      'tenantId': tenantId,
      'propertyTaxRate': propertyTaxRate,
    };
  }
  
factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      id: json['id'],
      ownerId: json['ownerId'],
      location: json['location'],
      squareMeters: json['squareMeters'],
      rooms: json['rooms'],
      isRented: json['isRented'],
      monthlyRent: json['monthlyRent'],
      tenantId: json['tenantId'],
      propertyTaxRate: json['propertyTaxRate'],
      name: json['name'],
      value: json['value'],
      age: json['age'],
      condition: AssetCondition.values.firstWhere(
        (e) => e.toString() == json['condition'],
        orElse: () => AssetCondition.good,
      ),
      maintenanceCost: json['maintenanceCost'],
      isInsured: json['isInsured'],
      insuranceCost: json['insuranceCost'],
    );
  }
  
  @override
  void updateValue() {
    super.updateValue();
    // Logique spécifique aux biens immobiliers
    if (isRented) {
      value *= 1.02; // Appréciation supplémentaire si loué
    }
  }
  
  @override
  void deteriorate() {
    if (Random().nextDouble() < 0.2) {
      int index = AssetCondition.values.indexOf(condition);
      if (index < AssetCondition.values.length - 1) {
        condition = AssetCondition.values[index + 1];
      }
    }
    value *= 0.98;
  }
}
