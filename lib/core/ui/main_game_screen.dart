import 'package:bitlife_like/core/ui/widgets/game_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/age_service.dart';
import 'package:bitlife_like/core/services/event_service.dart';
//import 'package:bitlife_like/core/ui/stat_section.dart';

//import 'package:bitlife_like/core/shared/stat_data.dart';
import 'package:bitlife_like/core/models/character.dart';

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
      body: Column(),
    );
  }
}