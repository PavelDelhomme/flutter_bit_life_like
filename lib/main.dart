import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/models/character.dart';
import 'plugin_manager.dart';
import 'plugins/core_plugins/assets_extended/models/adapters/antique.adapter.dart';
import 'plugins/core_plugins/assets_extended/models/adapters/arme.adapter.dart';
import 'plugins/core_plugins/assets_extended/models/adapters/assets.adapter.dart';
import 'plugins/core_plugins/assets_extended/models/adapters/jewelry.adapter.dart';
import 'plugins/core_plugins/assets_extended/models/adapters/real_estate.adapter.dart';
import 'plugins/core_plugins/assets_extended/models/adapters/vehicle.adapter.dart';

import 'core/services/game_state_service.dart';
import 'core/models/character.adapter.dart';
import 'core/plugin/game_plugin_context.dart';
import 'core/services/data_service.dart';
import 'core/services/legal_service.dart';
import 'core/services/save_manager.dart';
import 'core/services/skill_tree_manager.dart';
import 'core/shared/adapters/bank_account.adapter.dart';
import 'core/shared/legal.dart';
import 'core/ui/character_creation_screen.dart';
import 'core/ui/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Initialisation Hive
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

  // Préchargement des données
  await DataService.preloadCities();

  await SkillTreeManager().loadSkillTree();

  // Initialisation des services
  LegalService.initialize(await LegalSystem.loadDefaultSystems());

  final character = await SaveManager.loadMainCharacter(); // ou en dur

  runApp(BitLifeApp(initialCharacter: character));
}

class BitLifeApp extends StatelessWidget {
  final Character? initialCharacter;

  const BitLifeApp({super.key, required this.initialCharacter});

  @override
  Widget build(BuildContext context) {
    if (initialCharacter != null) {
      GameStateService.instance.setCharacter(initialCharacter!);
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

    return MaterialApp(
      title: 'BitLife Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: GameStateService.instance.navigatorKey,
      home: const StartScreen(savedCharacters: []),
      routes: {
        '/start': (context) => const StartScreen(savedCharacters: []),
        '/characterCreation': (context) => CharacterCreationScreen(),
        ...PluginManager.instance.getAllRoutes(),
      },
    );
  }
}
