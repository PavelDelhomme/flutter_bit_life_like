import 'dart:math';

enum PetType {
  dog,
  cat,
  bird,
  rodent,
  reptile,
  fish,
  exotic,
}

class Pet {
  String id;
  String name;
  String species;
  String breed;
  int age;
  double health;
  double happiness;
  String ownerId;
  DateTime birthdate;

  Pet({
    String? id,
    required this.name,
    required this.species,
    this.breed = '',
    this.age = 0,
    this.health = 100.0,
    this.happiness = 100.0,
    required this.ownerId,
    DateTime? birthdate,
  }) :
    id = id ?? 'pet_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}',
    birthdate = birthdate ?? DateTime.now();

  
  void ageUp() {
    age++;
    // Réduction naturelle de la santé avec l'âge
    health -= Random().nextDouble() * 5;
    health = health.clamp(0.0, 100.0);
  }
  
  void feed() {
    happiness += Random().nextDouble() * 10;
    happiness = happiness.clamp(0.0, 100.0);
  }
  
  void pet() {
    happiness += Random().nextDouble() * 15;
    happiness = happiness.clamp(0.0, 100.0);
  }
  
  void takeToVet() {
    health += Random().nextDouble() * 20 + 10;
    happiness -= Random().nextDouble() * 10; // Les animaux n'aiment pas le vétérinaire
    health = health.clamp(0.0, 100.0);
    happiness = happiness.clamp(0.0, 100.0);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'health': health,
      'happiness': happiness,
      'ownerId': ownerId,
      'birthdate': birthdate.toIso8601String(),
    };
  }
  
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      age: json['age'],
      health: json['health'],
      happiness: json['happiness'],
      ownerId: json['ownerId'],
      birthdate: DateTime.parse(json['birthdate']),
    );
  }
}