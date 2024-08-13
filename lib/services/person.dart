import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

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
    }
  }

  Person getRandomCharacter() {
    if (availableCharacters.isEmpty) {
      // On peux choisir de créer un personnage par défaut ou de lever une exception
      throw Exception("No available characters to select from.");
    }
    final random = Random();
    return availableCharacters[random.nextInt(availableCharacters.length)];
  }
}