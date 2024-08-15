import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Classes/life_history_event.dart';

class LifeHistoryService {
  static const String _fileName = 'life_history.json';

  // Enregistrer un nouvel événement
  Future<void> saveEvent(LifeHistoryEvent event) async {
    final file = await _getLocalFile();

    if (file == null) {
      print("Error: File could not be created.");
      return;
    }

    List<LifeHistoryEvent> events = await getEvents();
    events.add(event);
    final jsonData = events.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));  // Ajout de await ici pour garantir que l'écriture est asynchrone
  }

  // Récupérer les événements
  Future<List<LifeHistoryEvent>> getEvents() async {
    try {
      final file = await _getLocalFile();

      if (file == null) {
        print("Error: File could not be created.");
        return [];
      }

      if (await file.exists()) {
        String content = await file.readAsString();
        List<dynamic> jsonData = jsonDecode(content);
        return jsonData.map((json) => LifeHistoryEvent.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error reading events: $e");
      return [];
    }
  }

  // Obtenir l'emplacement du fichier local
  Future<File?> _getLocalFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$_fileName';
      return File(path);
    } catch (e) {
      print("Error getting application documents directory: $e");
      return null;
    }
  }
}
