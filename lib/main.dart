import 'package:bitlife_like/models/asset/assets.adapter.dart';
import 'package:bitlife_like/models/asset/jewelry.adapter.dart';
import 'package:bitlife_like/models/asset/real_estate.adapter.dart';
import 'package:bitlife_like/models/asset/vehicle.adapter.dart';
import 'package:bitlife_like/models/economy/bank_account.adapter.dart';
import 'package:bitlife_like/models/legal.dart';
import 'package:bitlife_like/services/data_service.dart';
import 'package:bitlife_like/services/legal/legal_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'models/asset/antique.adapter.dart';
import 'models/asset/arme.adapter.dart';
import 'models/person/character.adapter.dart';
import 'screens/start_screen.dart';
import 'package:hive/hive.dart';

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

  // Initialisation des services
  LegalService.initialize(await LegalSystem.loadDefaultSystems());

  runApp(const BitLifeApp());
}

class BitLifeApp extends StatelessWidget {
  const BitLifeApp({Key? key}) : super(key: key);

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
