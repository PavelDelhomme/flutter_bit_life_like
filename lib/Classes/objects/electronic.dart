class Electronic {
  String id;
  String type; // Par exemple : smartphone, laptop, server,...
  String brand;
  String model;
  double price;
  bool supportsApplications; // Indique si l'appareil peut exécuter des applications

  Electronic({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.price,
    this.supportsApplications = false,
  });

  factory Electronic.fromJson(Map<String, dynamic> json) {
    return Electronic(
      id: json['id'],
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      price: json['price'],
      supportsApplications: json['supportsApplications'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'price': price,
      'supportsApplications': supportsApplications,
    };
  }
}