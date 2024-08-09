import '../../services/bank/bank_account.dart';

class Electronic implements Purchasable {
  String id;
  String type; // Par exemple : smartphone, laptop, server,...
  String brand;
  String model;
  double value;
  bool supportsApplications; // Indique si l'appareil peut exécuter des applications

  Electronic({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.value,
    this.supportsApplications = false,
  });

  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      value: json['value'],
      supportsApplications: json['supportsApplications'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'value': value,
      'supportsApplications': supportsApplications,
    };
  }
}