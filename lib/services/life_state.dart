import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:bit_life_like/Classes/ficalite/evasion_fiscale.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/relationship.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:bit_life_like/services/person.dart';
import 'package:path_provider/path_provider.dart';
import '../Classes/objects/antique.dart';
import '../Classes/objects/arme.dart';
import '../Classes/objects/book.dart';
import '../Classes/objects/electronic.dart';
import '../Classes/objects/instrument.dart';
import '../Classes/objects/jewelry.dart';
import '../Classes/objects/vehicles/avion.dart';
import '../Classes/objects/vehicles/bateau.dart';
import '../Classes/objects/vehicles/moto.dart';
import '../Classes/objects/vehicles/voiture.dart';
import '../Classes/person.dart';
import '../Classes/life_history_event.dart';

class LifeStateService {
  final PersonService personService;

  LifeStateService({required this.personService});

  // Sauvegarde de l'état complet d'une vie
  Future<void> saveLifeState(Person person) async {
    final file = await _getLifeStateFile(person);

    // Transformation des relations en JSON
    final relationshipsData = person.relationships.map((key, value) => MapEntry(key, value.toJson()));

    // Création du dictionnaire qui représente les données de la vie
    final lifeData = {
      'person': person.toJson(),
      'events': person.lifeHistory.map((e) => e.toJson()).toList(),
      'assets': {
        'bankAccounts': person.bankAccounts.map((b) => b.toJson()).toList(),
        'offshoreAccounts': person.offshoreAccounts.map((o) => o.toJson()).toList(),
        'antiques': person.antiques.map((a) => a.toJson()).toList(),
        'armes': person.armes.map((a) => a.toJson()).toList(),
        'arts': person.arts.map((a) => a.toJson()).toList(),
        'books': person.books.map((b) => b.toJson()).toList(),
        'electronics': person.electronics.map((e) => e.toJson()).toList(),
        'intruments': person.instruments.map((i) => i.toJson()).toList(),
        'jewelries': person.jewelries.map((j) => j.toJson()).toList(),
        'realEstates': person.realEstates.map((r) => r.toJson()).toList(),
        'motos': person.motos.map((m) => m.toJson()).toList(),
        'voitures': person.voitures.map((v) => v.toJson()).toList(),
        'bateaux': person.bateaux.map((b) => b.toJson()).toList(),
        'avions': person.avions.map((a) => a.toJson()).toList(),
      },
      'skills': person.skills,
      'educations': person.educations.map((ed) => ed.toJson()).toList(),
      'academicPerformance': person.academicPerformance,

      'relationships': relationshipsData,
      'parents': person.parents.map((parent) => parent.toJson()).toList(),
      'children': person.children.map((children) => children.toJson()).toList(),
      'friends': person.friends.map((friend) => friend.toJson()).toList(),
      'partners': person.partners.map((partner) => partner.toJson()).toList(),
      'sibling': person.siblings.map((sibling) => sibling.toJson()).toList(),
      'neighbors': person.neighbors.map((neighbor) => neighbor.toJson()).toList()
    };
    await file.writeAsString(jsonEncode(lifeData));
  }

  Future<Map<String, dynamic>?> loadLifeState(Person person) async {
    try {
      final file = await _getLifeStateFile(person);
      if (await file.exists()) {
        String content = await file.readAsString();
        final data = jsonDecode(content);

        person.voitures = (data['assets']['voitures'] as List<dynamic>).map((v) => Voiture.fromJson(v)).toList();
        person.motos = (data['assets']['motos'] as List<dynamic>).map((m) => Moto.fromJson(m)).toList();
        person.bateaux = (data['assets']['bateaux'] as List<dynamic>).map((b) => Bateau.fromJson(b)).toList();
        person.avions = (data['assets']['avions'] as List<dynamic>).map((a) => Avion.fromJson(a)).toList();

        person.jewelries = (data['assets']['jewelries'] as List<dynamic>).map((j) => Jewelry.fromJson(j)).toList();
        person.antiques = (data['assets']['antiques'] as List<dynamic>).map((a) => Antique.fromJson(a)).toList();
        person.electronics = (data['assets']['electronics'] as List<dynamic>).map((e) => Electronic.fromJson(e)).toList();
        person.books = (data['assets']['books'] as List<dynamic>).map((b) => Book.fromJson(b)).toList();
        person.instruments = (data['assets']['instruments'] as List<dynamic>).map((i) => Instrument.fromJson(i)).toList();
        person.armes = (data['assets']['instruments'] as List<dynamic>).map((a) => Arme.fromJson(a)).toList();
        person.realEstates = (data['assets']['realEstates'] as List<dynamic>).map((r) => RealEstate.fromJson(r)).toList();

        person.skills = Map<String, double>.from(data['skills'] ?? {});

        // Restauration des relations
        final relationshipsData = data['relationships'] as Map<String, dynamic>;
        relationshipsData.forEach((key, relData) {
          final relatedPerson = personService.getPersonById(key);

          if (relatedPerson != null) {
            person.relationships[key] = Relationship.fromJson(relData, relatedPerson);
          } else {
            log("Person with ID key not found when restoring relationships for ${person.name}");
          }

          person.relationships[key] = Relationship.fromJson(relData, relatedPerson);
        });

        log("Etat sauvegardé trouvé pour ${person.name}");
        return data;
      } else {
        log("Aucun état sauvegardé trouvé pour ${person.name}");
        return null;
      }
    } catch (e) {
      print("Erreur lors du chargement de l'état de vie pour ${person.name}: $e");
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
        person.offshoreAccounts = (data['assets']['offshoreAccounts'] as List<dynamic>)
            .map((json) => OffshoreAccount.fromJson(json))
            .toList();
        person.voitures = (data['assets']['voitures'] as List<dynamic>)
            .map((json) => Voiture.fromJson(json))
            .toList();
        person.motos = (data['assets']['motos'] as List<dynamic>)
            .map((json) => Moto.fromJson(json))
            .toList();
        person.bateaux = (data['assets']['bateaux'] as List<dynamic>)
            .map((json) => Bateau.fromJson(json))
            .toList();
        person.avions = (data['assets']['avions'] as List<dynamic>)
            .map((json) => Avion.fromJson(json))
            .toList();
        person.jewelries = (data['assets']['jewelries'] as List<dynamic>)
            .map((json) => Jewelry.fromJson(json))
            .toList();
        person.antiques = (data['assets']['antiques'] as List<dynamic>)
            .map((json) => Antique.fromJson(json))
            .toList();
        person.electronics = (data['assets']['electronics'] as List<dynamic>)
            .map((json) => Electronic.fromJson(json))
            .toList();
        person.books = (data['assets']['books'] as List<dynamic>)
            .map((json) => Book.fromJson(json))
            .toList();
        person.instruments = (data['assets']['instruments'] as List<dynamic>)
            .map((json) => Instrument.fromJson(json))
            .toList();
        person.armes = (data['assets']['armes'] as List<dynamic>)
            .map((json) => Arme.fromJson(json))
            .toList();
        person.realEstates = (data['assets']['realEstates'] as List<dynamic>)
            .map((json) => RealEstate.fromJson(json))
            .toList();
      }
    } catch (e) {
      log("Failed to load life details for ${person.name}: $e");
    }
  }


  Person? getPersonById(String id) {
    try {
      Person? person = personService.getPersonById(id);
      if (person == null) {
        log("Aucune personne trouvée avec l'ID $id");
      }
      return person;
    } catch (e) {
      log("Erreur lors de la récupération de la personne avec l'ID $id : $e");
      return null;
    }
    // Méthode fictive pour récupérer une personne par son ID
    return personService.getPersonById(id); // Cette méthode doit être complétée en fonction de votre implémentation
  }

}
