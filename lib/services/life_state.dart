import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:bit_life_like/Classes/relationship.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:bit_life_like/services/person.dart';
import 'package:path_provider/path_provider.dart';
import '../Classes/person.dart';
import '../Classes/life_history_event.dart';

class LifeStateService {
  final PersonService personService;

  LifeStateService({required this.personService});

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
      'assets': {
        'bankAccounts': person.bankAccounts.map((b) => b.toJson()).toList(),
        'collectibles': person.collectibles.map((c) => c.toJson()).toList(),
        'vehicles': person.vehicles.map((v) => v.toJson()).toList(),
        'vehiculesExotiques': person.vehiculeExotiques.map((ve) => ve.toJson()).toList(),
        'educations': person.educations.map((ed) => ed.toJson()).toList(),
        'academicPerformance': person.academicPerformance,
        'parents': person.parents.map((parent) => parent.toJson()).toList(),
        'children': person.children.map((children) => children.toJson()).toList(),
        'friends': person.friends.map((friend) => friend.toJson()).toList(),
        'partners': person.partners.map((partner) => partner.toJson()).toList(),
        'sibling': person.siblings.map((sibling) => sibling.toJson()).toList(),
        'neighbors': person.neighbors.map((neighbor) => neighbor.toJson()).toList()
      }
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
          final relatedPerson = getPersonById(key);
          person.relationships[key] = Relationship.fromJson(relData, relatedPerson);
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

  Future<void> loadLifeDetails(Person person) async {
    try {
      final data = await loadLifeState(person);
      if (data != null) {
        final events = (data['events'] as List<dynamic>)
            .map((eventJson) => LifeHistoryEvent.fromJson(eventJson))
            .toList();
        person.lifeHistory = events;

        // Récupération d'actifs
        person.bankAccounts = (data['assets']['bankAccounts'] as List<dynamic>)
            .map((json) => BankAccount.fromJson(json))
            .toList();
      }
    } catch (e) {
      log("Failed to load life details for ${person.name}: $e");
    }
  }


  Person getPersonById(String id) {
    // Méthode fictive pour récupérer une personne par son ID
    return personService.getPersonById(id); // Cette méthode doit être complétée en fonction de votre implémentation
  }

}
