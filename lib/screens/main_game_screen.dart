import 'package:bit_life_like/screens/character_creation_screen.dart';
import 'package:bit_life_like/screens/start_screen.dart';
import 'package:flutter/material.dart';
import '../models/character.dart';
import '../widgets/stat_bar.dart';
import '../widgets/event_history.dart';
import '../widgets/bottom_navigation.dart';

class MainGameScreen extends StatefulWidget {
  final Character character;

  const MainGameScreen({Key? key, required this.character}) : super(key: key);

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  late Character _character;

  @override
  void initState() {
    super.initState();
    _character = widget.character;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        title: const Text('BitLife'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
            ),
            child: const Text(
              'CITIZEN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
              ),
              child: Text(
                _character.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Sauvegarder'),
              onTap: () {
                // Logique de sauvegarde
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Nouvelle vie'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CharacterCreationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Mes vies'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartScreen(savedCharacters: []),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // En-tête avec informations du personnage
          Container(
            color: const Color(0xFFE53935),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.brown.shade200,
                      radius: 30,
                      child: const Icon(
                        Icons.child_care,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _character.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _character.currentTitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_character.money.toStringAsFixed(0)} \$',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Historique de vie
          Expanded(
            child: EventHistory(lifeEvents: _character.lifeEvents),
          ),
          
          // Statistiques
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                StatBar(
                  label: 'Bonheur',
                  value: _character.stats['happiness'] ?? 0,
                  icon: Icons.emoji_emotions,
                  color: Colors.green,
                ),
                const SizedBox(height: 5),
                StatBar(
                  label: 'Santé',
                  value: _character.stats['health'] ?? 0,
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
                const SizedBox(height: 5),
                StatBar(
                  label: 'Intelligence',
                  value: _character.stats['intelligence'] ?? 0,
                  icon: Icons.psychology,
                  color: Colors.orange,
                ),
                const SizedBox(height: 5),
                StatBar(
                  label: 'Apparence',
                  value: _character.stats['appearance'] ?? 0,
                  icon: Icons.face,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
          
          // Barre de navigation du bas
          const BottomNavigation(),
        ],
      ),
    );
  }
}
