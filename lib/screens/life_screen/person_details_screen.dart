import 'dart:developer';

import 'package:bit_life_like/Classes/life_history_event.dart';
import 'package:bit_life_like/Classes/objects/antique.dart';
import 'package:bit_life_like/Classes/objects/electronic.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:bit_life_like/Classes/objects/vehicles/avion.dart';
import 'package:bit_life_like/Classes/objects/vehicles/bateau.dart';
import 'package:bit_life_like/Classes/objects/vehicles/moto.dart';
import 'package:bit_life_like/Classes/objects/vehicles/voiture.dart';
import 'package:bit_life_like/Classes/relationship.dart';
import 'package:bit_life_like/screens/life_screen/vehicle_list_screen.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../Classes/objects/collectible_item.dart';
import '../../Classes/objects/real_estate.dart';
import '../../Classes/person.dart';
import '../../services/life_state.dart';
import '../work/classes/education.dart';

class PersonDetailsScreen extends StatefulWidget {
  final Person person;

  PersonDetailsScreen({required this.person});

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}


class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  final LifeStateService lifeStateService = LifeStateService(personService: personService);

  Future<void> _loadLifeDetails(BuildContext context) async {
    try {
      final data = await lifeStateService.loadLifeState(widget.person);
      if (data != null) {
        // Restaurer l'historique de vie
        final events = (data['events'] as List<dynamic>)
            .map((eventJson) => LifeHistoryEvent.fromJson(eventJson))
            .toList();
        widget.person.lifeHistory = events;

        // Restaurer les relations
        final relationshipsData = data['relationships'] as Map<String, dynamic>;
        relationshipsData.forEach((key, relData) {
          final relatedPerson = personService.getPersonById(key);
          if (relatedPerson != null) {
            widget.person.relationships[key] =
                Relationship.fromJson(relData, relatedPerson);
          }
        });

        // Restaurer les parents
        final parentsData = data['assets']['parents'] as List<dynamic>;
        widget.person.parents = parentsData.map((parentJson) {
          return Person.fromJson(parentJson);
        }).toList();

        // Restaurer les enfants
        final childrenData = data['assets']['children'] as List<dynamic>;
        widget.person.children = childrenData.map((childJson) {
          return Person.fromJson(childJson);
        }).toList();

        // Restaurer les amis
        final friendsData = data['assets']['friends'] as List<dynamic>;
        widget.person.friends = friendsData.map((friendJson) {
          return Person.fromJson(friendJson);
        }).toList();

        // Restaurer les partenaires
        final partnersData = data['assets']['partners'] as List<dynamic>;
        widget.person.partners = partnersData.map((partnerJson) {
          return Person.fromJson(partnerJson);
        }).toList();

        // Restaurer les frères et sœurs
        final siblingsData = data['assets']['siblings'] as List<dynamic>;
        widget.person.siblings = siblingsData.map((siblingJson) {
          return Person.fromJson(siblingJson);
        }).toList();

        // Restaurer les voisins
        final neighborsData = data['assets']['neighbors'] as List<dynamic>;
        widget.person.neighbors = neighborsData.map((neighborJson) {
          return Person.fromJson(neighborJson);
        }).toList();

        // Restaurer les comptes bancaires
        widget.person.bankAccounts = (data['assets']['bankAccounts'] as List<dynamic>)
            .map((json) => BankAccount.fromJson(json))
            .toList();

        // Restaurer les véhicules
        widget.person.voitures = (data['assets']['voitures'] as List<dynamic>)
            .map((json) => Voiture.fromJson(json))
            .toList();
        widget.person.bateaux = (data['assets']['bateaux'] as List<dynamic>)
            .map((json) => Bateau.fromJson(json))
            .toList();
        widget.person.motos = (data['assets']['motos'] as List<dynamic>)
            .map((json) => Moto.fromJson(json))
            .toList();
        widget.person.avions = (data['assets']['avions'] as List<dynamic>)
            .map((json) => Avion.fromJson(json))
            .toList();

        // Restaurer les biens immobiliers
        widget.person.realEstates = (data['assets']['realEstates'] as List<dynamic>)
            .map((json) => RealEstate.fromJson(json))
            .toList();

        widget.person.antiques = (data['assets']['antiques'] as List<dynamic>)
            .map((json) => Antique.fromJson(json))
            .toList();
        widget.person.jewelries = (data['assets']['jewelries'] as List<dynamic>)
            .map((json) => Jewelry.fromJson(json))
            .toList();
        widget.person.electronics = (data['assets']['electronics'] as List<dynamic>)
            .map((json) => Electronic.fromJson(json))
            .toList();


        // Restaurer les éducations
        widget.person.educations = (data['assets']['educations'] as List<dynamic>)
            .map((json) => EducationLevel.fromJson(json))
            .toList();

        // Restaurer la performance académique
        widget.person.academicPerformance = data['assets']['academicPerformance'];

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Life details loaded successfully!"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No saved life details found."),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to load life details!"),
      ));
      log("Failed to load life details: $e");
    }
  }


  Future<void> _saveLife(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedLives = prefs.getString('lives');
      List<dynamic> lives = [];

      if (savedLives != null) {
        lives = jsonDecode(savedLives);
      }

      // Vérifiez si cette vie existe déjà et mettez-la à jour
      int existingIndex = lives.indexWhere((life) => life['id'] == widget.person.id);
      if (existingIndex != -1) {
        lives[existingIndex] = widget.person.toJson();
        log("Life updated: ${widget.person.name}");
      } else {
        lives.add(widget.person.toJson());
        log("New life added: ${widget.person.name}");
      }

      // Sauvegarde via SharedPreferences
      await prefs.setString('lives', jsonEncode(lives));
      // Sauvegarde complète via le LifeStateService
      await lifeStateService.saveLifeState(widget.person);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Life saved successfully!"),
      ));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to save life!"),
      ));
      log("Failed to save life! : $e");
    }
  }

  void _showInheritance(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Inheritance Details"),
          content: Text("You have inherited some valuable items and money."),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.person.name} Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveLife(context), // Sauvegarde de la vie
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _loadLifeDetails(context),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Health"),
            subtitle: Text("${widget.person.health.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Happiness"),
            subtitle: Text("${widget.person.happiness.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Intelligence"),
            subtitle: Text("${widget.person.intelligence.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Karma"),
            subtitle: Text("${widget.person.karma.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Stress Level"),
            subtitle: Text("${widget.person.stressLevel.toStringAsFixed(0)}%"),
          ),
          ExpansionTile(
            title: Text("Job History"),
            children: widget.person.jobHistory.map((job) {
              return ListTile(
                title: Text(job.title),
                subtitle: Text("Company: ${job.companyName}"),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text("Skills"),
            children: widget.person.skills.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text("Level: ${(entry.value * 100).toStringAsFixed(1)}%"),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text("Education History"),
            children: widget.person.educations.map((education) {
              return ListTile(
                title: Text(education.name),
                subtitle: Text("Completed: ${education.duration} years"),
              );
            }).toList(),
          ),
          ListTile(
            title: Text("Permits"),
            subtitle: Text(widget.person.permits.join(" | ")),
          ),
          ExpansionTile(
            title: Text("Vehicles"),
            children: <Widget>[
              ListTile(
                title: Text("Voitures (${widget.person.voitures.length})"),
                onTap: () => _showVehicleList(context, "Voitures", widget.person.voitures),
              ),
              ListTile(
                title: Text("Motos (${widget.person.motos.length})"),
                onTap: () => _showVehicleList(context, "Motos", widget.person.motos),
              ),
              ListTile(
                title: Text("Bateaux (${widget.person.bateaux.length})"),
                onTap: () => _showVehicleList(context, "Bateaux", widget.person.bateaux),
              ),
              ListTile(
                title: Text("Avions (${widget.person.avions.length})"),
                onTap: () => _showVehicleList(context, "Avions", widget.person.avions),
              ),
            ],
          ),
          ListTile(
            title: Text("View Inheritance"),
            onTap: () => _showInheritance(context),
          ),
        ],
      ),
    );
  }

  void _showVehicleList(BuildContext context, String title, List<dynamic> vehicles) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleListScreen(title: title, vehicles: vehicles),
      ),
    );
  }
}
