import 'package:bitlife_like/core/ui/events_screens/event_history.dart';
import 'package:bitlife_like/core/ui/navigation_screens/bottom_navigation.dart';
import 'package:bitlife_like/core/ui/profile_screens/profile_screen.dart';
import 'package:bitlife_like/core/ui/relationships_screens/relationships_screen.dart';
import 'package:bitlife_like/core/ui/stats_screens/stat_bar.dart';
import 'package:bitlife_like/core/ui/widgets/game_drawer.dart';
import 'package:bitlife_like/core/ui/work_screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/age_service.dart';
import 'package:bitlife_like/core/services/event_service.dart';
//import 'package:bitlife_like/core/ui/stat_section.dart';

//import 'package:bitlife_like/core/shared/stat_data.dart';
import 'package:bitlife_like/core/models/character.dart';

import '../../plugin_manager.dart';
import 'activities_screen/activites_screen.dart';
import 'capital_screens/capital_screen.dart';

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

    PluginManager.instance.registerAll();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // forcer le rebuild en revenant de PluginManagerPage
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: GameDrawer(character: _character),
      body: Column(
        children: [
         // En-tête personnage
         GestureDetector(
           onTap: _navigateToProfileScreen,
           child: InkWell(
             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => ProfileScreen(character: _character)),
               );
             },
             child: Container(
               color: Colors.red.shade100,
               padding: const EdgeInsets.all(12),
               child: Row(
                 children: [
                   const CircleAvatar(
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

          // Bottom navigation
          BottomNavigation(
            onAgePressed: () async {
              await GameStateService.instance.ageService.ageUp(_character);
              setState(() {});
            },
            onWorkPressed: _navigateToWorkScreen,
            onAssetsPressed: _navigateToAssetsScreen,
            onRelationsPressed: _navigateToRelationsScreen,
            onActivitiesPressed: _navigateToActivitiesScreen,
          )
        ],
      ),
    );
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(character: _character)),
    );
  }

  void _navigateToWorkScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WorkScreen(character: _character)),
    );
  }

  void _navigateToAssetsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CapitalScreen(character: _character)),
    );
  }

  void _navigateToRelationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RelationshipsScreen(character: _character)),
    );
  }

  void _navigateToActivitiesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ActivitiesScreen(character: _character)),
    );
  }
}