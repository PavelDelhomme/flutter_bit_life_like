import 'package:bit_life_like/screens/work/classes/job.dart';
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
    _initializePersonService();
  }

  Future<void> _initializePersonService() async {
    await personService.loadCharacters();
    setState(() {
      // Update state if necessary after loading characters
    });
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
    try {

      if (personService.availableCharacters.isEmpty) {
        print("No characters available. Please check JSON loading.");
        return;
      }

      final person = Person(
        name: _nameController.text.isNotEmpty ? _nameController.text : 'John Doe', // Nom par défaut
        gender: 'Male', // Exemple par défaut
        country: _selectedCountry,
        age: 0,
        intelligence: 100,
        happiness: 100,
        karma: 100,
        appearance: 100,
        health: 100,
        isImprisoned: false,
        prisonTerm: 0,
        bankAccounts: [],
      );

      // Générer une famille, des amis, etc.
      person.parents = _generateRandomFamily(_selectedCountry);

      for (var parent in person.parents) {
        parent.manageFinances(); // Simulation d'un mois de gestion financiere
      }

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
    } catch (e) {
      print("Error creating life: $e");
    }
  }

  List<Person> _generateRandomFamily(String country) {
    return List.generate(2, (_) {
      Person parent = personService.getRandomCharacter();
      parent.country = country;
      parent.bankAccounts = _generateRandomBankAccounts();
      parent.jobs = [_generateRandomJob(country)]; // Assigne un emploi aléatoire
      return parent;
    });
  }


  List<BankAccount> _generateRandomBankAccounts() {
    final random = Random();
    return List.generate(1, (_) {
      return BankAccount(
        accountNumber: 'ACC${random.nextInt(1000000)}',
        bankName: 'Global Bank',
        balance: random.nextDouble() * 10000 + 1000, // Solde initial aléatoire
        annualIncome: random.nextDouble() * 50000 + 20000, // Revenu annuel aléatoire
        accountType: 'Checking',
      );
    });
  }

  Job _generateRandomJob(String country) {
    final random = Random();
    List<String> jobTitles = ['Engineer', 'Teacher', 'Doctor', 'Artist', 'Manager'];
    List<String> companyNames = ['TechCorp', 'EduWorld', 'HealthCare Inc.', 'ArtStudio', 'BusinessSolutions'];

    return Job(
      title: jobTitles[random.nextInt(jobTitles.length)],
      country: country,
      salary: random.nextDouble() * 40 + 20, // Salaire par heure aléatoire
      hoursPerWeek: random.nextInt(20) + 20,
      companyName: companyNames[random.nextInt(companyNames.length)],
      isFullTime: random.nextBool(),
    );
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
