import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

import '../Classes/person.dart';


class PersonService {
  List<Person> availableCharacters = [];

  Future<void> loadCharacters() async {
    try {
      String data = await rootBundle.loadString('assets/characters.json');
      List<dynamic> jsonResult = jsonDecode(data);

      availableCharacters = jsonResult.map((characterJson) {
        return Person.fromJson(characterJson);
      }).toList();

      print("Loaded ${availableCharacters.length} characters.");
    } catch (e) {
      print("Error loading characters: $e");
      print("Generating 10 default character");
      _generateRandomCharacters(10);
    }

    if (availableCharacters.isEmpty) {
      _generateRandomCharacters(10); // SI la liste est vie tu en génère 10
    }
  }

  void _generateRandomCharacters(int count) {
    List<String> names = ['John', 'Alice', 'Bob', 'Eve', 'Charlie', 'Dave', 'Maya', 'Sophia', 'Jack', 'Emma'];
    List<String> countries = ['USA', 'France', 'Germany', 'Japan', 'Brazil', 'Canada'];
    List<String> genders = ['Male', 'Female'];
    final random = Random();

    availableCharacters = List.generate(count, (_) {
      String name = names[random.nextInt(names.length)];
      String country = countries[random.nextInt(countries.length)];
      String gender = genders[random.nextInt(genders.length)];

      return Person(
        name: name,
        gender: gender,
        country: country,
        age: random.nextInt(100),
        intelligence: random.nextDouble() * 100,
        happiness: random.nextDouble() * 100,
        karma: random.nextDouble() * 100,
        appearance: random.nextDouble() * 100,
        health: random.nextDouble() * 100,
        isImprisoned: false,
        prisonTerm: 0,
        bankAccounts: [],
      );
    });

    print("Generated ${availableCharacters.length} random characters.");
  }

  Person getRandomCharacter() {
    if (availableCharacters.isEmpty) {
      // On peux choisir de créer un personnage par défaut ou de lever une exception
      throw Exception("No available characters to select from.");
    }
    final random = Random();
    return availableCharacters[random.nextInt(availableCharacters.length)];
  }

  Person? getPersonById(String id) {
    return availableCharacters.firstWhereOrNull((person) => person.id == id);
  }

}