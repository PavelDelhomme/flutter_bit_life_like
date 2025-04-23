import 'package:bitlife_like/core/ui/stat_bar.dart';
import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/age_service.dart';
import 'package:bitlife_like/core/services/event_service.dart';
//import 'package:bitlife_like/core/ui/stat_section.dart';

//import 'package:bitlife_like/core/shared/stat_data.dart';
import 'package:bitlife_like/plugin_manager.dart';
import 'package:bitlife_like/core/models/character.dart';

import '../../plugins/career_plugins/work_system/screen/work_screen.dart';
import '../../plugins/core_plugins/activity_plugin/widgets/activities_screen.dart';
import '../../plugins/core_plugins/assets_extended/widgets/assets_screen.dart';
import '../../plugins/social_plugins/vie_familiale/widgets/relationships_screen.dart';
import 'bottom_navigation.dart';
import 'event_history.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  late Character _character;
  // ignore: unused_field
  late AgeService _ageService;
  // ignore: unused_field
  late EventService _eventService;

  @override
  void initState() {
    super.initState();
    final gameState = GameStateService.instance;
    _character = gameState.character;
    _eventService = gameState.eventService;
    _ageService = gameState.ageService;
  }
  /*
  void _handleAgeUp()
  {
    setState(() {
      _ageService.ageUp(_character);
      _showAgeUpDialog();
    });
  }
   */
  /*
  void _showAgeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nouvel âge atteint"),
        content: Text("Vous avez maintenant ${_character.age} ans."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
   */

  /*
  void _navigateTo(String routeName)
  {
    Navigator.pushNamed(context, routeName);
  }
   */

  @override
  Widget build(BuildContext context) {
    /*final stateSections = [
      StatSection(
        title: 'Vie',
        stats: [
          StatData(label: "Santé", icon: Icons.favorite, value: _character.stats["health"] ?? 0, color: Colors.red),
          StatData(label: "Bonheur", icon: Icons.emoji_emotions, value: _character.stats["happiness"] ?? 0, color: Colors.orange),
        ],
      ),
      StatSection(
        title: "Compétences",
        stats: [
          StatData(label: "Intelligence", icon: Icons.psychology, value: _character.stats["intelligence"] ?? 0, color: Colors.blue),
          StatData(label: "Apparence", icon: Icons.face, value: _character.stats["appearance"] ?? 0, color: Colors.pink),
        ],
      ),
    ];*/

    //final pluginMenus = PluginManager.instance.getMainMenuItems(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("BitLife Like"),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('${_character.money.toStringAsFixed(0)} \$')),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              child: Text(
                _character.fullName,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text("Sauvegarder"),
              onTap: () {
                // TODO: Ajouter GameStateService.instance.saveGame();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text("Nouvelle vie"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/characterCreation');
              },
            ),
            ...PluginManager.instance.getMainMenuItems(context).map((entry) => ListTile(
              leading: Icon(entry.icon),
              title: Text(entry.title),
              onTap: entry.onTap,
            )),
          ],
        ),
      ),
      body: Column(
        children: [
          // En-tête personnage
          Container(
            color: Colors.red.shade100,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_character.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${_character.age} ans - ${_character.currentTitle}"),
                    ],
                  ),
                ),
                Text('${_character.money.toStringAsFixed(0)} \$'),
              ],
            ),
          ),

          // Event history
          Expanded(child: EventHistory(lifeEvents: _character.lifeEvents)),

          // Stat bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                StatBar(
                  label: "Santé",
                  value: _character.stats['health'] ?? 0,
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
                StatBar(
                  label: "Bonheur",
                  value: _character.stats['happiness'] ?? 0,
                  icon: Icons.emoji_emotions,
                  color: Colors.amber,
                ),
                StatBar(
                  label: "Intelligence",
                  value: _character.stats['intelligence'] ?? 0,
                  icon: Icons.psychology,
                  color: Colors.blue,
                ),
                StatBar(
                  label: "Apparence",
                  value: _character.stats['appearance'] ?? 0,
                  icon: Icons.face,
                  color: Colors.pink,
                ),
              ],
            ),
          ),

          // Bottom nav
          BottomNavigation(
            onAgePressed: () async {
              await GameStateService.instance.ageService.ageUp(_character);
              setState(() {}); // Mettre à jour l’écran après le vieillissement
            },
            onWorkPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkScreen()));
            },
            onAssetsPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetsScreen()));
            },
            onRelationsPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RelationshipsScreen()));
            },
            onActivitiesPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivitiesScreen()));
            },
          )
        ],
      ),
    );
  }
}