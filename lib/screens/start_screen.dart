import 'dart:convert';
import 'dart:developer';
import 'package:bit_life_like/Classes/relationship.dart';
import 'package:bit_life_like/screens/life_screen/person_details_screen.dart';
import 'package:bit_life_like/services/life_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Classes/life_history_event.dart';
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
      try {
        List<dynamic> decoded = jsonDecode(savedLives);
        List<Person> loadedLives = [];
        for (var data in decoded) {
          if (data is Map<String, dynamic>) {
            Person person = Person.fromJson(data);
            if (!person.isPNJ) {
              loadedLives.add(person);
              await _loadLifeDetailsFromFile(person);
            }
          } else {
            log("Data is not in the expected format: $data");
          }
        }

        setState(() {
          lives = loadedLives; // Assurez-vous que lives est bien mis à jour dans le setState
          log("Lives loaded: ${lives.map((e) => e.name).toList()}");

        });
      } catch (e) {
        log("Error during deserialization: $e");
      }
    }
  }

  Future<void> _loadLifeDetailsFromFile(Person person) async {
    final LifeStateService lifeStateService =
        LifeStateService(personService: personService);
    final data = await lifeStateService.loadLifeState(person);

    if (data != null) {
      setState(() {
        person.lifeHistory = (data['events'] as List<dynamic>)
            .map((eventJson) => LifeHistoryEvent.fromJson(eventJson))
            .toList();

        // Restaurer d'autres données complexes comme les relations
        final relationshipsData = data['relationships'] as Map<String, dynamic>;
        relationshipsData.forEach((key, relData) {
          final relatedPerson = personService.getPersonById(key);
          if (relatedPerson != null) {
            person.relationships[key] =
                Relationship.fromJson(relData, relatedPerson);
          }
        });
      });
    }
  }

  Future<void> _saveLives() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonLives =
        lives.map((life) => life.toJson()).toList();
    await prefs.setString('lives', jsonEncode(jsonLives));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Lives Screen'),
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
                  subtitle:
                      Text('Age: ${person.age}, Country: ${person.country}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(
                                person: person,
                                realEstateService: RealEstateService(),
                                transactionService: TransactionService(),
                                eventMaps: widget.events,
                            ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bool? confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Deletion"),
                            content: Text("Are you sure you want to delete this life?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        setState(() {
                          lives.removeAt(index);
                        });
                        await LifeStateService(personService: personService).deleteLifeState(person);
                        await _saveLives();
                      }
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Utiliser await pour s'assurer que tout est bien sauvegardé avant de retourner à l'écran des vies
              final newLife = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewLifeScreen(
                    lives: lives,
                    events: widget.events,
                  ),
                ),
              );

              if (newLife != null) {
                // Ajouter la nouvelle vie à la liste et sauvegarder
                setState(() {
                  lives.add(newLife); // Ajouter la nouvelle vie
                });

                await _saveLives(); // Sauvegarder la nouvelle liste de vies
              }
            },
            child: Text('Start New Life'),
          ),
        ],
      ),
    );
  }
}
