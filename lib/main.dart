import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bit_life_like/screens/start_screen.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestPermissions();

  // Charger les données des événements depuis un fichier JSON
  String eventData = await rootBundle.loadString('assets/events.json');
  List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(jsonDecode(eventData)['events']);

  // Charger les données bancaires avant de démarrer l'application
  await FinancialService.loadBankData();

  // Exécuter l'application avec les événements chargés
  runApp(MyApp(events: events));
}

Future<void> _requestPermissions() async {
  // Demande des permission de stockage pour Android/iOS
  PermissionStatus status = await Permission.storage.request();

  if (!status.isGranted) {
    // Si la permission est refusée, vous pouvez afficher un message ou alors il faut fermer l'application
    print("Permission de stockage refusée");
  }
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  MyApp({required this.events});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartScreen(events: events), // Utiliser StartScreen comme écran principal
      debugShowCheckedModeBanner: false,
    );
  }
}
