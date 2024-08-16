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
      print("Erreur: Le fichier n'a pas pu être créé.");
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
        print("Erreur: Le fichier n'a pas pu être créé.");
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
      print("Erreur lors de la lecture des événements: $e");
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
      print("Erreur lors de l'obtention du répertoire des documents: $e");
      return null;
    }
  }
}
