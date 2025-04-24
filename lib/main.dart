import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/save_manager.dart';
import 'package:bitlife_like/plugin_manager.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/adapters/antique.adapter.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/adapters/arme.adapter.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/adapters/assets.adapter.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/adapters/jewelry.adapter.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/adapters/real_estate.adapter.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/adapters/vehicle.adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/models/character.adapter.dart';
import 'core/models/character.dart';
import 'core/plugin/game_plugin_context.dart';
import 'core/services/data_service.dart';
import 'core/services/legal_service.dart';
import 'core/services/skill_tree_manager.dart';
import 'core/shared/adapters/bank_account.adapter.dart';
import 'core/shared/legal.dart';
import 'core/ui/creation_screens/character_creation_screen.dart';
import 'core/ui/starting_screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation Hive
  await Hive.initFlutter();
  await Hive.deleteBoxFromDisk('main_characters');

  Hive
    ..registerAdapter(CharacterAdapter())
    ..registerAdapter(AssetAdapter())
    ..registerAdapter(AntiqueAdapter())
    ..registerAdapter(ArmeAdapter())
    ..registerAdapter(RealEstateAdapter())
    ..registerAdapter(JewelryAdapter())
    ..registerAdapter(VehicleAdapter())
    ..registerAdapter(BankAccountAdapter());

  await SaveManager.initialize();
  await DataService.preloadCities();
  await SkillTreeManager().loadSkillTree();
  LegalService.initialize(await LegalSystem.loadDefaultSystems());

  final allCharacters = SaveManager.getAllMainCharacters().where((c) => !c.isPNJ).toList();

  if (allCharacters.isNotEmpty) {
    GameStateService.instance.setCharacter(allCharacters.first);
    GameStateService.instance.initializeWorld();

    PluginManager.instance.registerAll();
    PluginManager.instance.startGamePlugins(
      GamePluginContext(
        mainCharacter: GameStateService.instance.character,
        gameState: GameStateService.instance,
        eventService: GameStateService.instance.eventService,
      ),
    );
  }

  runApp(BitLifeApp(
    initialCharacter: allCharacters.isNotEmpty ? allCharacters.first : null,
    savedCharacters: allCharacters,
  ));
}

class BitLifeApp extends StatelessWidget {
  final Character? initialCharacter;
  final List<Character> savedCharacters;

  const BitLifeApp({super.key, required this.initialCharacter, required this.savedCharacters});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitLife Like',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: GameStateService.instance.navigatorKey,
      home: StartScreen(savedCharacters: savedCharacters),
      routes: {
        '/start': (context) => StartScreen(savedCharacters: savedCharacters),
        '/characterCreation': (context) => CharacterCreationScreen(),
        ...PluginManager.instance.getAllRoutes(), // <- routes dynamiques des plugins
      },
    );
  }
}
