import 'package:bitlife_like/core/services/game_state_service.dart';
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
import 'core/services/data_service.dart';
import 'core/services/legal_service.dart';
import 'core/services/skill_tree_manager.dart';
import 'core/shared/adapters/bank_account.adapter.dart';
import 'core/shared/legal.dart';
import 'core/ui/character_creation_screen.dart';
import 'core/ui/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation Hive
  Hive
    ..initFlutter()
    ..registerAdapter(CharacterAdapter())
    ..registerAdapter(AssetAdapter())
    ..registerAdapter(AntiqueAdapter())
    ..registerAdapter(ArmeAdapter())
    ..registerAdapter(RealEstateAdapter())
    ..registerAdapter(JewelryAdapter())
    ..registerAdapter(VehicleAdapter())
    ..registerAdapter(BankAccountAdapter())
  ;

  // Préchargement des données
  await DataService.preloadCities();

  await SkillTreeManager().loadSkillTree();

  // Initialisation des services
  LegalService.initialize(await LegalSystem.loadDefaultSystems());

  runApp(const BitLifeApp());
}

class BitLifeApp extends StatelessWidget {
  const BitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
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
