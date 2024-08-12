import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bit_life_like/screens/home_screen.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:bit_life_like/Classes/person.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Person newPerson = createNewPerson();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  person: newPerson,
                  realEstateService: RealEstateService(),
                  transactionService: TransactionService(),
                ),
              ),
            );
          },
          child: Text('Start New Life'),
        ),
      ),
    );
  }

  Person createNewPerson() {
    // Generate random name, gender, and country
    String name = 'John Doe'; // Use a random generator for names
    String gender = 'Male'; // Randomize gender
    String country = 'USA'; // Randomize country

    // Create a new Person with random attributes
    Person person = Person(
      name: name,
      gender: gender,
      country: country,
      age: 0,
      health: 100,
      appearance: 100,
      karma: 100,
      happiness: 100,
      intelligence: 100,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [],
    );

    // Generate a family
    generateFamily(person);

    return person;
  }

  void generateFamily(Person person) {
    // Generate random parents
    Person mother = Person(
      name: 'Jane Doe',
      gender: 'Female',
      country: person.country,
      age: 35,
      health: 100,
      appearance: 100,
      karma: 100,
      happiness: 100,
      intelligence: 100,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [],
    );

    Person father = Person(
      name: 'Jack Doe',
      gender: 'Male',
      country: person.country,
      age: 36,
      health: 100,
      appearance: 100,
      karma: 100,
      happiness: 100,
      intelligence: 100,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [],
    );

    person.parents.add(mother);
    person.parents.add(father);

    // Optionally generate siblings
    if (Random().nextBool()) {
      Person sibling = Person(
        name: 'Sam Doe',
        gender: Random().nextBool() ? 'Male' : 'Female',
        country: person.country,
        age: person.age + 2, // Sibling 2 years older
        health: 100,
        appearance: 100,
        karma: 100,
        happiness: 100,
        intelligence: 100,
        isImprisoned: false,
        prisonTerm: 0,
        bankAccounts: [],
      );

      person.parents[Random().nextInt(2)].partners.add(sibling); // Add sibling to a random parent
    }
  }
}
