import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

import '../Classes/person.dart';
import 'bank/bank_account.dart';


class PersonService {
  List<Person> availableCharacters = [];
  Map<String, List<String>> namesByGender = {};

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

  Future<void> loadNames() async {
    try {
      String data = await rootBundle.loadString('assets/names.json');
      namesByGender = jsonDecode(data).cast<String, List<String>>();
    } catch (e) {
      print("Error loading names: $e");
    }
  }

  void _generateRandomCharacters(int count) {
    List<String> countries = ['USA', 'France', 'Germany', 'Japan', 'Brazil', 'Canada'];
    List<String> genders = ['Male', 'Female'];
    final random = Random();

    availableCharacters = List.generate(count, (_) {
      String country = countries[random.nextInt(countries.length)];
      String gender = genders[random.nextInt(genders.length)];
      String name = getRandomName(gender);

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
        bankAccounts: [createInitialBankAccount()],
      );
    });

    print("Generated ${availableCharacters.length} random characters.");
  }

  Person transertAssetsToChild(Person parent, Person child) {
    child.bankAccounts.addAll(parent.bankAccounts);
    child.vehiculeExotiques.addAll(parent.vehiculeExotiques);

  }

  String getRandomName(String gender) {
    if (namesByGender.isEmpty) {
      throw Exception("Names not loaded. Call 'loadNames()' first.");
    }

    List<String> names = namesByGender[gender.toLowerCase()] ?? [];
    return names.isNotEmpty ? names[Random().nextInt(names.length)] : "Unknown";
  }

  BankAccount createInitialBankAccount() {
    final random = Random();
    return BankAccount(
      accountNumber: 'ACC${random.nextInt(1000000)}',
      bankName: 'Global Bank',
      balance: random.nextDouble() * 10000 + 500,
    );
  }

  Person getRandomCharacter() {
    if (availableCharacters.isEmpty) {
      // On peux choisir de créer un personnage par défaut ou de lever une exception
      throw Exception("No available characters to select from.");
    }
    final random = Random();
    return availableCharacters[random.nextInt(availableCharacters.length)];
  }

  Person getPersonById(String id) {
    return availableCharacters.firstWhere((person) => person.id == id, orElse: () {
      throw Exception("Person with id $id not found");
    });
  }

  Person generatePNJ({
    required String gender,
    required String country,
    required int minAge,
    required int maxAge,
  }) {
    final random = Random();
    int age = random.nextInt(maxAge - minAge + 1) + minAge;

    Person pnj = Person(
      name: getRandomName(gender),
      gender: gender,
      country: country,
      age: age,
      intelligence: random.nextDouble() * 100,
      happiness: random.nextDouble() * 100,
      karma: random.nextDouble() * 100,
      appearance: random.nextDouble() * 100,
      health: random.nextDouble() * 100,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [createInitialBankAccount()],
    );

    availableCharacters.add(pnj);
    return pnj;
  }
}