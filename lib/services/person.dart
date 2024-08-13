import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../Classes/person.dart';


class PersonService {
  List<Person> availableCharacters = [];

  Future<void> loadCharacters() async {
    String data = await rootBundle.loadString('assets/characters.json');
    List<dynamic> jsonResult = jsonDecode(data);

    availableCharacters = jsonResult.map((characterJson) {
      return Person.fromJson(characterJson);
    }).toList();
  }

  Person getRandomCharacter() {
    final random = Random();
    return availableCharacters[random.nextInt(availableCharacters.length)];
  }
}