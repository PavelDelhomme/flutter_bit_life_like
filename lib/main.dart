import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bit_life_like/screens/start_screen.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Ajout du package device_info_plus

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les données des événements depuis un fichier JSON
  String eventData = await rootBundle.loadString('assets/events.json');
  List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(jsonDecode(eventData)['events']);

  // Charger les données bancaires avant de démarrer l'application
  await FinancialService.loadBankData();

  // Exécuter l'application avec les événements chargés
  runApp(MyApp(events: events));
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
      home: PermissionScreen(events: events), // Nouvel écran pour gérer les permissions
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
  bool _isRequestingPermission = false; // Booléen pour vérifier si une requête est en cours

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (_isRequestingPermission) return; // Si une demande est déjà en cours, ne rien faire

    _isRequestingPermission = true; // Marquer qu'une requête est en cours

    try {
      // Si Android est de niveau 33 (Android 13) ou supérieur, ne pas demander la permission de stockage
      if (await _isAndroid13OrAbove()) {
        // Permissions spécifiques aux médias pour Android 13+
        PermissionStatus imagePermission = await Permission.photos.status;
        PermissionStatus videoPermission = await Permission.videos.status;

        if (!imagePermission.isGranted || !videoPermission.isGranted) {
          // Demander les permissions spécifiques aux médias
          await Permission.photos.request();
          await Permission.videos.request();
        }
      } else {
        // Pour les versions antérieures à Android 13, demander la permission de stockage
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
      }

      // Si les permissions sont accordées, naviguer vers l'écran principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StartScreen(events: widget.events),
        ),
      );
    } finally {
      _isRequestingPermission = false; // Réinitialiser après la fin de la requête
    }
  }

  // Fonction pour vérifier si Android est de version 13 ou supérieure
  Future<bool> _isAndroid13OrAbove() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 33;
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
