import 'package:bitlife_like/plugins/assets_extended/models/adapters/antique.adapter.dart';
import 'package:bitlife_like/plugins/assets_extended/models/adapters/arme.adapter.dart';
import 'package:bitlife_like/plugins/assets_extended/models/adapters/assets.adapter.dart';
import 'package:bitlife_like/plugins/assets_extended/models/adapters/jewelry.adapter.dart';
import 'package:bitlife_like/plugins/assets_extended/models/adapters/real_estate.adapter.dart';
import 'package:bitlife_like/plugins/assets_extended/models/adapters/vehicle.adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/models/character.adapter.dart';
import 'core/services/data_service.dart';
import 'core/services/legal_service.dart';
import 'core/services/skill_tree_manager.dart';
import 'core/shared/legal.dart';
import 'core/ui/StartScreen.dart';

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
      home: const StartScreen(savedCharacters: []),
      debugShowCheckedModeBanner: false,
    );
  }
}
