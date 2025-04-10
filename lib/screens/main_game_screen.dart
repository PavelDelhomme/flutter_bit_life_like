import 'package:flutter/material.dart';

import 'package:bitlife_like/screens/character_creation_screen.dart';
import 'package:bitlife_like/screens/start_screen.dart';

import 'package:bitlife_like/widgets/stat_bar.dart';
import 'package:bitlife_like/widgets/event_history.dart';
import 'package:bitlife_like/widgets/bottom_navigation.dart';

import 'package:bitlife_like/services/age_service.dart';
import 'package:bitlife_like/services/bank/financial_service.dart';
import 'package:bitlife_like/services/events/events_decision/event_service.dart';

import 'package:bitlife_like/models/person/stat_data.dart';
import 'package:bitlife_like/models/person/character.dart';

import 'submenus/relationships_menus/menus/relationships_screen.dart';
import 'submenus/activities_menus/menus/activities_screen.dart';
import 'submenus/career_menus/menus/work_screen.dart';
import 'submenus/assets_menus/menus/assets_menu_screen.dart';

class MainGameScreen extends StatefulWidget {
  final Character character;

  const MainGameScreen({super.key, required this.character});

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  late Character _character;
  late AgeService _ageService;

  @override
  void initState() {
    super.initState();
    _character = widget.character;
    _ageService = AgeService(EventService(), FinancialService());
  }

  void _handleAgeUp() {
    setState(() {
      _ageService.ageUp(_character);
      _showAgeUpDialog();
    });
  }

  void _showAgeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvel Age"),
        content: Text('Vous avez maintenant ${_character.age} ans'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        title: const Text('BitLife'),
        leading: Builder(
          builder: (context) =>
              IconButton(
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
                    builder: (context) =>
                    const StartScreen(savedCharacters: []),
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
          // Container(
          //   padding: const EdgeInsets.all(15),
          //   child: Column(
          //     children: [
          //       _buildStatSection('VIE', [
          //         StatData(
          //             label: 'Santé',
          //             icon: Icons.favorite,
          //             value: _character.stats['health'] ?? 0,
          //             color: Colors.red
          //         ),
          //         StatData(
          //             label: 'Bonheur',
          //             icon: Icons.emoji_emotions,
          //             value: _character.stats['happiness'] ?? 0,
          //             color: Colors.amber
          //         ),
          //       ]),
          //       _buildStatSection('CAPACITÉS', [
          //         StatData(
          //             label: 'Intelligence',
          //             icon: Icons.psychology,
          //             value: _character.stats['intelligence'] ?? 0,
          //             color: Colors.blue
          //         ),
          //         StatData(
          //             label: 'Apparence',
          //             icon: Icons.face,
          //             value: _character.stats['appearance'] ?? 0,
          //             color: Colors.pink
          //         )
          //       ]),
          //     ],
          //   ),
          // ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildExpandableStatSection('VIE', [
                      StatData(
                        label: 'Santé',
                        icon: Icons.favorite,
                        value: _character.stats['health'] ?? 0,
                        color: Colors.red
                      ),
                      StatData(
                        label: 'Bonheur',
                        icon: Icons.emoji_emotions,
                        value: _character.stats['happiness'] ?? 0,
                        color: Colors.amber
                      ),
                    ]),
                    _buildClickableStatSection(),
                  ],
                ),
              ),
            ),
          ),

          BottomNavigation(
            onAgePressed: () => _handleAgeUp(),
            onWorkPressed: () => _navigateToWorkScreen(),
            onAssetsPressed: () => _navigateToAssetsScreen(),
            onRelationsPressed: () => _navigateToRelationsScreen(),
            onActivitiesPressed: () => _navigateToActivitiesScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableStatSection(String title, List<StatData> stats) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        ...stats.map((stat) => StatBar(
          label: stat.label,
          value: stat.value,
          icon: stat.icon,
          color: stat.color,
        )),
      ],
    );
  }
  
  Widget _buildClickableStatSection() {
    return InkWell(
      onTap: _showDetailedStatsDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.more_horiz, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'CAPACITÉS ET COMPÉTENCES',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  void _showDetailedStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Statistiques détaillées'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildStatItem('Intelligence', _character.stats['intelligence'] ?? 0, Colors.blue),
              _buildStatItem('Apparence', _character.stats['appearance'] ?? 0, Colors.pink),
              _buildStatItem('Force', _character.stats['strength'] ?? 0, Colors.orange),
              _buildStatItem('Charisme', _character.stats['charisma'] ?? 0, Colors.purple),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }


  Widget _buildStatItem(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('${value.toStringAsFixed(0)}%'),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToWorkScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WorkScreen(jobs: [],)),
    );
  }
  
  void _navigateToAssetsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssetsMenuScreen(
        assets: _character.assets,
      )),
    );
  }


  void _navigateToRelationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RelationshipsScreen()),
    );
  }

  void _navigateToActivitiesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
    );
  }


  Widget _buildStatSection(String title, List<StatData> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ...stats.map((stat) => StatBar(
          label: stat.label,
          value: stat.value,
          icon: stat.icon,
          color: stat.color,
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}