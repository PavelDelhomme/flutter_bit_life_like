// models/asset.dart
import 'dart:math';

enum AssetType {
  bankAccount,
  realEstate,
  vehicle,
  jewelry,
  art,
  antique,
  weapon,
  electronic,
  book,
  instrument,
  stock,
  crypto,
  business
}

enum AssetCondition {
  excellent,
  good,
  average,
  poor,
  terrible
}



class Asset {
  final String id;
  final AssetType type;
  String ownerId;
  String name;
  double value;
  int age;
  AssetCondition condition;
  double maintenanceCost;
  bool isInsured;
  double insuranceCost;
  double monthlyIncome;
  double depreciationRate;
  double appreciationRate;
  Map<String, dynamic> specificProperties;
  
  Asset({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.name,
    required this.value,
    this.age = 0,
    this.condition = AssetCondition.good,
    this.maintenanceCost = 0.0,
    this.isInsured = false,
    this.insuranceCost = 0.0,
    this.monthlyIncome = 0.0,
    this.depreciationRate = 0.05, // 5% par an
    this.appreciationRate = 0.0,
    Map<String, dynamic>? specificProperties,
  }) : specificProperties = specificProperties ?? {};
  
  void age1Year() {
    age++;
    
    // Dégradation naturelle de l'état
    if (condition != AssetCondition.terrible) {
      double degradationChance = 0.1 + (age * 0.01);
      if (degradationChance > 0.5) degradationChance = 0.5;
      
      if (degradationChance > (Random().nextDouble())) {
        int currentIndex = AssetCondition.values.indexOf(condition);
        if (currentIndex < AssetCondition.values.length - 1) {
          condition = AssetCondition.values[currentIndex + 1];
        }
      }
    }
    
    // Évolution de la valeur
    updateValue();
  }
  
  void updateValue() {
    // Dépréciation basée sur l'âge et l'état
    double conditionFactor = 1.0;
    switch (condition) {
      case AssetCondition.excellent:
        conditionFactor = 1.0;
        break;
      case AssetCondition.good:
        conditionFactor = 0.9;
        break;
      case AssetCondition.average:
        conditionFactor = 0.7;
        break;
      case AssetCondition.poor:
        conditionFactor = 0.5;
        break;
      case AssetCondition.terrible:
        conditionFactor = 0.3;
        break;
    }
    
    // Calcul de la nouvelle valeur
    double newValue = value;
    
    // Dépréciation basée sur l'âge
    newValue *= (1 - depreciationRate);
    
    // Appréciation possible (pour immobilier, art, etc.)
    newValue *= (1 + appreciationRate);
    
    // Facteur d'état
    newValue *= conditionFactor;
    
    value = newValue;
  }
  
  void maintain() {
    // Amélioration de l'état suite à l'entretien
    if (condition != AssetCondition.excellent) {
      int currentIndex = AssetCondition.values.indexOf(condition);
      if (currentIndex > 0) {
        condition = AssetCondition.values[currentIndex - 1];
      }
    }
  }

  void deteriorate() {
    // Implémentation de base pour tous les assets
    if (Random().nextDouble() < 0.1) {
      int index = AssetCondition.values.indexOf(condition);
      if (index < AssetCondition.values.length - 1) {
        condition = AssetCondition.values[index + 1];
      }
    }
    value *= (1 - depreciationRate);
  }

  void transferOwnership(String newOwnerId) {
    ownerId = newOwnerId;
  }

  double get marketValue => value * (1 - depreciationRate * age);


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'type': type.toString(),
      'name': name,
      'value': value,
      'age': age,
      'condition': condition.toString(),
      'maintenanceCost': maintenanceCost,
      'isInsured': isInsured,
      'insuranceCost': insuranceCost,
      'monthlyIncome': monthlyIncome,
      'depreciationRate': depreciationRate,
      'appreciationRate': appreciationRate,
      'specificProperties': specificProperties,
    };
  }
  
  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      ownerId: json['ownerId'],
      type: AssetType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AssetType.bankAccount,
      ),
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
      monthlyIncome: json['monthlyIncome'],
      depreciationRate: json['depreciationRate'],
      appreciationRate: json['appreciationRate'],
      specificProperties: json['specificProperties'],
    );
  }
}