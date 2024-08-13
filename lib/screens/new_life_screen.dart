import 'package:bit_life_like/services/person.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../Classes/person.dart';
import '../services/bank/bank_account.dart';
import 'home_screen.dart';
import '../services/bank/transaction_service.dart';
import '../services/real_estate/real_estate.dart';

class NewLifeScreen extends StatefulWidget {
  final List<Person> lives;

  NewLifeScreen({required this.lives});

  @override
  _NewLifeScreenState createState() => _NewLifeScreenState();
}

class _NewLifeScreenState extends State<NewLifeScreen> {
  final _nameController = TextEditingController();
  String _selectedCountry = 'USA';
  final _countries = ['USA', 'France', 'Germany', 'Japan', 'Brazil', 'Canada'];
  final PersonService personService = PersonService();

  @override
  void initState() {
    super.initState();
    personService.loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Life'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            DropdownButton<String>(
              value: _selectedCountry,
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value ?? 'USA';
                });
              },
            ),
            ElevatedButton(
              onPressed: _createLife,
              child: Text('Start Life'),
            ),
          ],
        ),
      ),
    );
  }

  void _createLife() {
    final person = personService.getRandomCharacter();
    person.name =
        _nameController.text.isNotEmpty ? _nameController.text : person.name;
    person.country = _selectedCountry;

    // Générer une famille, des amis etc.
    person.parents = _generateRandomFamily(_selectedCountry);
    person.friends = _generateRandomFriends(_selectedCountry, person.age, 3);
    person.neighbors = _generateRandomNeighbors(person.country, 5);

    widget.lives.add(person);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          person: person,
          realEstateService: RealEstateService(),
          transactionService: TransactionService(),
          events: [], // Pass events if needed
        ),
      ),
    );
  }

  List<Person> _generateRandomFamily(String country) {
    return [
      personService.getRandomCharacter(),
      personService.getRandomCharacter()
    ];
  }

  List<Person> _generateRandomFriends(
      String country, int age, int numberOfFriends) {
    return List.generate(numberOfFriends, (index) {
      Person friend = personService.getRandomCharacter();
      friend.country = country;
      friend.age = age;
      return friend;
    });
  }

  List<Person> _generateRandomNeighbors(String country, int numberOfNeighbors) {
    return List.generate(numberOfNeighbors, (index) {
      Person neighbor = personService.getRandomCharacter();
      neighbor.country = country;
      neighbor.age = Random().nextInt(75) + 5;
      return neighbor;
    });
  }
}
