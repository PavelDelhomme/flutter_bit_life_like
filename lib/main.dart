import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bit_life_like/screens/start_screen.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

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
  PermissionStatus status = await Permission.storage.status;

  if (!status.isGranted) {
    // Redemande la permission jusqu'à ce qu'elle soit accordée
    while (!status.isGranted) {
      // Demande la permission
      status = await Permission.storage.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        // Si l'utilisateur refuse ou bloque définitivement la permission, on affiche un message
        await showDialog(
          context: navigatorState.currentState!.context, // Nécessite un GlobalKey pour accéder au contexte
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Permission nécessaire'),
            content: const Text(
                'L\'application a besoin de la permission de stockage pour fonctionner correctement.'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  // Redirige l'utilisateur vers les paramètres si la permission est définitivement refusée
                  if (status.isPermanentlyDenied) {
                    await openAppSettings();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Paramètres'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // Ferme l'application
                child: const Text('Quitter'),
              ),
            ],
          ),
        );
      }
    }
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
      home: PermissionScreen(events: events), // Utiliser StartScreen comme écran principal
      debugShowCheckedModeBanner: false,
    );
  }
}

class PermissionScreen extends StatefulWidget {
  final List<Map<String, dynamic>> events;

  PermissionScreen({required this.events});

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      // Redemande la permission jusqu'à ce qu'elle soit accordée
      while (!status.isGranted) {
        // Demande la permission
        status = await Permission.storage.request();

        if (status.isDenied || status.isPermanentlyDenied) {
          // Si la permission est refusée ou définitivement bloquée, affiche une boîte de dialogue
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Permission nécessaire'),
              content: Text(
                  'L\'application a besoin de la permission de stockage pour fonctionner correctement.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (status.isPermanentlyDenied) {
                      await openAppSettings(); // Ouvre les paramètres de l'application
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Paramètres'),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(), // Ferme l'application
                  child: Text('Quitter'),
                ),
              ],
            ),
          );
        }
      }
    }

    // Si la permission est accordée, naviguer vers l'écran principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartScreen(events: widget.events),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Affiche un écran de chargement pendant la vérification des permissions
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}