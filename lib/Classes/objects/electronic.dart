class Electronic {
  final String id;
  final String type; // Par exemple : smartphone, laptop, server,...
  final String brand;
  final String model;
  final double value;
  final bool supportsApplications;

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
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      supportsApplications: json['supportsApplications'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'price': value,
      'supportsApplications': supportsApplications,
    };
  }

  String display() {
    return '$brand $model ($type) - Value: \$${value.toStringAsFixed(2)}';
  }
}
