import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Classes/person.dart';
import '../services/bank/transaction_service.dart';
import '../services/real_estate/real_estate.dart';
import 'new_life_screen.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> events;

  StartScreen({required this.events});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  List<Person> lives = [];

  @override
  void initState() {
    super.initState();
    _loadLives();
  }

  Future<void> _loadLives() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedLives = prefs.getString('lives');

    if (savedLives != null) {
      List<dynamic> decoded = jsonDecode(savedLives);
      setState(() {
        lives = decoded.map((data) => Person.fromJson(data)).toList();
      });
    }
  }

  Future<void> _saveLives() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonLives = lives.map((life) => life.toJson()).toList();
    await prefs.setString('lives', jsonEncode(jsonLives));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start a New Life'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lives.length,
              itemBuilder: (context, index) {
                final person = lives[index];
                return ListTile(
                  title: Text(person.name),
                  subtitle: Text('Age: ${person.age}, Country: ${person.country}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          person: person,
                          realEstateService: RealEstateService(),
                          transactionService: TransactionService(),
                          events: widget.events,
                        ),
                      ),
                    ).then((_) => _loadLives()); // Recharger la liste après le retour
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewLifeScreen(lives: lives)),
              ).then((_) => _loadLives()); // Recharger la liste après la création d'une nouvelle vie
            },
            child: Text('Start New Life'),
          ),
        ],
      ),
    );
  }
}
