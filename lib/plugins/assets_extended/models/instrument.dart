
import '../../../core/models/asset.dart';
import '../../../core/shared/inventory_item.dart';

class Instrument extends Asset implements InventoryItem {
  final String typeInstrument;

  Instrument({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.value,
    this.typeInstrument = "guitar",
    super.age = 0,
    super.condition = AssetCondition.good,
    super.maintenanceCost = 0.0,
  }) : super(type: AssetType.instrument, appreciationRate: 0.05);


  @override
  Map<String, double> get skillEffects => {
    "music": 5.0,
  };

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'typeInstrument': typeInstrument,
    };
  }

  factory Instrument.fromJson(Map<String, dynamic> json) {
    return Instrument(
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
      typeInstrument: json['typeInstrument'] ?? "guitar",
    );
  }
}