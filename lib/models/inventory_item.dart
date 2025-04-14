abstract class InventoryItem {
  String get id;
  String get name;
  double get value;
  String get type;

  Map<String, double> get skillEffects => {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'type': type,
    };
  }
}
