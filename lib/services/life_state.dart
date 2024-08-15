import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../Classes/person.dart';
import '../Classes/life_history_event.dart';

class LifeStateService {
  // Sauvegarde de l'état complet d'une vie
  Future<void> saveLifeState(
      Person person, List<LifeHistoryEvent> events) async {
    final file = await _getLifeStateFile(person);
    final lifeData = {
      'person': person.toJson(),
      'events': events.map((e) => e.toJson()).toList(),
    };
    await file.writeAsString(jsonEncode(lifeData));
  }

  // Charger l'état d'une vie à partir d'un fichier
  Future<Map<String, dynamic>?> loadLifeState(Person person) async {
    try {
      final file = await _getLifeStateFile(person);
      if (await file.exists()) {
        String content = await file.readAsString();
        log("Etat sauvegarder trouve");
        return jsonDecode(content);
      } else {
        log("Aucun état sauvegardé trouvé");
        return null; // Aucun état sauvegardé trouvé
      }
    } catch (e) {
      print("Error loading life state: $e");
      return null;
    }
  }

  // Supprimer l'état d'une vie
  Future<void> deleteLifeState(Person person) async {
    final file = await _getLifeStateFile(person);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Obtenir le fichier de sauvegarde pour une vie donnée
  Future<File> _getLifeStateFile(Person person) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'life_state_${person.id}.json';
    return File('${directory.path}/$fileName');
  }
}
