import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:bit_life_like/Classes/relationship.dart';
import 'package:path_provider/path_provider.dart';
import '../Classes/person.dart';
import '../Classes/life_history_event.dart';

class LifeStateService {
  // Sauvegarde de l'état complet d'une vie
  Future<void> saveLifeState(Person person, List<LifeHistoryEvent> events) async {
    final file = await _getLifeStateFile(person);

    // Transformation des relations en JSON
    final relationshipsData = person.relationships.map((key, value) => MapEntry(key, value.toJson()));

    // Création du dictionnaire qui représente les données de la vie
    final lifeData = {
      'person': person.toJson(),
      'events': events.map((e) => e.toJson()).toList(),
      'relationships': relationshipsData,
    };
    await file.writeAsString(jsonEncode(lifeData));
  }

  Future<Map<String, dynamic>?> loadLifeState(Person person) async {
    try {
      final file = await _getLifeStateFile(person);
      if (await file.exists()) {
        String content = await file.readAsString();
        final data = jsonDecode(content);

        // Restauration des relations
        final relationshipsData = data['relationships'] as Map<String, dynamic>;
        relationshipsData.forEach((key, relData) {
          final relatedPerson = personService.getPersonById(key);
          if (relatedPerson != null) {
            person.relationships[key] = Relationship.fromJson(relData, relatedPerson);
          }
        });

        log("Etat sauvegardé trouvé");
        return data;
      } else {
        log("Aucun état sauvegardé trouvé");
        return null;
      }
    } catch (e) {
      print("Erreur lors du chargement de l'état de vie: $e");
      return null;
    }
  }

  // Supprimer l'état d'une vie
  Future<void> deleteLifeState(Person person) async {
    final file = await _getLifeStateFile(person);
    if (await file.exists()) {
      await file.delete();
      log("État de vie supprimé pour ${person.name}");
    }
  }

  // Obtenir le fichier de sauvegarde pour une vie donnée
  Future<File> _getLifeStateFile(Person person) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'life_state_${person.id}.json';
    return File('${directory.path}/$fileName');
  }
}
