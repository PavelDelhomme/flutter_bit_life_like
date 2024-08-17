import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../Classes/person.dart';
import '../../services/life_state.dart';

class PersonDetailsScreen extends StatelessWidget {
  final Person person;
  final LifeStateService lifeStateService = LifeStateService();

  PersonDetailsScreen({required this.person});

  Future<void> _saveLife(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedLives = prefs.getString('lives');
      List<dynamic> lives = [];

      if (savedLives != null) {
        lives = jsonDecode(savedLives);
      }

      // Vérifiez si cette vie existe déjà et mettez-la à jour
      int existingIndex = lives.indexWhere((life) => life['id'] == person.id);
      if (existingIndex != -1) {
        lives[existingIndex] = person.toJson();
      } else {
        lives.add(person.toJson());
      }

      // Sauvegarde via SharedPreferences
      await prefs.setString('lives', jsonEncode(lives));

      // Sauvegarde complète via le LifeStateService
      await lifeStateService.saveLifeState(person, person.lifeHistory);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Life saved successfully!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to save life!"),
      ));
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
        title: Text("${person.name} Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveLife(context), // Sauvegarde de la vie
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Health"),
            subtitle: Text("${person.health.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Happiness"),
            subtitle: Text("${person.happiness.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Intelligence"),
            subtitle: Text("${person.intelligence.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Karma"),
            subtitle: Text("${person.karma.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Stress Level"),
            subtitle: Text("${person.stressLevel.toStringAsFixed(0)}%"),
          ),
          ExpansionTile(
            title: Text("Job History"),
            children: person.jobHistory.map((job) {
              return ListTile(
                title: Text(job.title),
                subtitle: Text("Company: ${job.companyName}"),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text("Skills"),
            children: person.skills.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text("Level: ${(entry.value * 100).toStringAsFixed(1)}%"),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text("Education History"),
            children: person.educations.map((education) {
              return ListTile(
                title: Text(education.name),
                subtitle: Text("Completed: ${education.duration} years"),
              );
            }).toList(),
          ),
          ListTile(
            title: Text("Permits"),
            subtitle: Text(person.permits.join(" | ")),
          ),
          ListTile(
            title: Text("View Inheritance"),
            onTap: () => _showInheritance(context),
          ),
        ],
      ),
    );
  }
}
