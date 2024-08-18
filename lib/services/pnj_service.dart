
import 'dart:math';

import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/job.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class PnjService {
  List<Person> allPNJs = [];

  Person generatePNJ({
    required String gender,
    required String country,
    required int minAge,
    required int maxAge,
    String? jobTitle,
    String? employerName,
    String? educationLevel,
  }) {
    final random = Random();
    int age = random.nextInt(maxAge - minAge + 1) + minAge;
    String name = getRandomName(gender);

    Person pnj = Person(
      name: name,
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
      bankAccounts: [], // Initier avec un compte bancaire par défaut avec un ACC quoi bref
    );

    allPNJs.add(pnj);
    return pnj;
  }

  List<Person> generateColleagues(String country, int count) {
    List<Person> colleagues = [];
    for (int i = 0; i < count; i++) {
      colleagues.add(generatePNJ(
        gender: getRandomGender(),
        country: country,
        minAge: 25,
        maxAge: 65,
      ));
    }
    return colleagues;
  }

  List<Person> generateClassmates(String country, int count) {
    List<Person> classmates = [];
    for (int i = 0; i < count; i++) {
      classmates.add(generatePNJ(
        gender: getRandomGender(),
        country: country,
        minAge: 10,
        maxAge: 20,
      ));
    }
    return classmates;
  }

  List<Person> generateFamily(String country) {
    List<Person> family = [];
    // Exemples de génération d'un père et d'une mère
    family.add(generatePNJ(
      gender: 'Male',
      country: country,
      minAge: 35,
      maxAge: 60,
    ));
    family.add(generatePNJ(
      gender: 'Female',
      country: country,
      minAge: 30,
      maxAge: 55,
    ));
    return family;
  }

  String getRandomName(String gender) {
    List<String> maleNames = ['John', 'Paul', 'Jake'];
    List<String> femaleNames = ['Alice', 'Sophia', 'Emma'];
    return gender == 'Male'
        ? maleNames[Random().nextInt(maleNames.length)]
        : femaleNames[Random().nextInt(femaleNames.length)];
  }

  String getRandomGender() {
    return Random().nextBool() ? 'Male' : 'Female';
  }

}