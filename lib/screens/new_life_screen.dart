import 'package:bit_life_like/screens/work/classes/job.dart';
import 'package:bit_life_like/services/person.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as dev;
import '../Classes/person.dart';
import '../services/bank/bank_account.dart';
import 'home_screen.dart';
import '../services/bank/transaction_service.dart';
import '../services/real_estate/real_estate.dart';

class NewLifeScreen extends StatefulWidget {
  final List<Person> lives;
  final List<Map<String, dynamic>> events;

  NewLifeScreen({required this.lives, required this.events});

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
              onPressed: () => _createLife(),
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
        dev.log("No characters available. Please check JSON loading.");
        return;
      }

      final person = Person(
          name: _nameController.text.isNotEmpty ? _nameController.text : 'John Doe',
          gender: 'Male',
          country: _selectedCountry,
          age: 0,
          intelligence: 100,
          happiness: 100,
          karma: 100,
          appearance: 100,
          health: 100,
          isImprisoned: false,
          prisonTerm: 0,
          bankAccounts: [_createInitialBankAccount()],
          lifeHistory: [] // Initialisation avec un historique vide
      );

      person.parents = _generateRandomFamily(_selectedCountry);

      // Ajouter la nouvelle vie principale
      widget.lives.add(person);

      // Naviguer vers la nouvelle vie (écran principal)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            person: person,
            realEstateService: RealEstateService(),
            transactionService: TransactionService(),
            eventMaps: widget.events,
          ),
        ),
      );
    } catch (e) {
      dev.log("Error creating life: $e");
    }
  }


  BankAccount _createInitialBankAccount() {
    return BankAccount(
      accountNumber: 'ACC${DateTime.now().millisecondsSinceEpoch}',
      bankName: 'Default Bank',
      balance: 0.0,
      accountType: 'Checking',
    );
  }

  List<Person> _generateRandomFamily(String country) {
    final random = Random();

    Person father = personService.getRandomCharacter();
    father.country = country;
    father.age = random.nextInt(20) + 35; // Age réaliste entre 35-55 ans
    father.bankAccounts = _generateRandomBankAccounts();
    father.jobs = [_generateRandomJob(country)];

    Person mother = personService.getRandomCharacter();
    mother.country = country;
    mother.age = random.nextInt(10) + father.age - 5;
    mother.bankAccounts = _generateRandomBankAccounts();
    mother.jobs = [_generateRandomJob(country)];

    return [father, mother];
  }

  List<BankAccount> _generateRandomBankAccounts() {
    final random = Random();
    return List.generate(1, (_) {
      return BankAccount(
        accountNumber: 'ACC${random.nextInt(1000000)}',
        bankName: 'Global Bank',
        balance: random.nextDouble() * 10000 + 1000,
        // Solde initial aléatoire
        annualIncome: random.nextDouble() * 50000 + 20000,
        // Revenu annuel aléatoire
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
}
