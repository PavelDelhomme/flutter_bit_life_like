import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Classes/event.dart';
import '../../Classes/person.dart';
import '../../screens/work/classes/job.dart';


class EventService {
  final List<Map<String, dynamic>> events;

  EventService({required this.events});

  void triggerRandomEvent(Person person, BuildContext context) {
    Random random = Random();
    for (var event in events) {
      if (random.nextDouble() < event['probability']) {
        _showEventDialog(person, event, context);
        break;
      }
    }
  }

  void _showEventDialog(Person person, Map<String, dynamic> event, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event['name']),
          content: Text(event['description']),
          actions: event['responses'].keys.map<Widget>((response) {
            return TextButton(
              child: Text(response),
              onPressed: () {
                _applyResponseEffects(person, event['responses'][response]);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _applyResponseEffects(Person person, Map<String, dynamic> effects) {
    effects.forEach((key, value) {
      switch (key) {
        case 'happiness':
          person.happiness += value;
          break;
        case 'health':
          person.health += value;
          break;
        case 'wealth':
          person.bankAccounts.first.balance += value;
          break;
        case 'karma':
          person.karma += value;
          break;
        case 'intelligence':
          person.intelligence += value;
          break;
        // AJouter d'autre cas possible des réponse genre effect avec els relation du coup
      }
    });
  }

  void applyEventEffects(Person person, Event event) {
    if (event.effects.containsKey('money') && person.bankAccounts.isNotEmpty) {
      double moneyChange = event.effects['money'];
      if (moneyChange > 0) {
        person.bankAccounts.first.deposit(moneyChange);
      } else {
        person.bankAccounts.first.withdraw(-moneyChange);
      }
    }
    if (event.effects.containsKey('health')) {
      person.health += event.effects['health'];
      person.health = person.health.clamp(0, 100);
    }
    // J'ajouterai plus d'effet sur les evenements et plus d'évènement plus tard
  }

  void applyChoiceEffects(Person person, Event event) {
    // Simulation du choix de l'uitlisateur cela devra être la récupération du choix graphique d'appuie sur le bouton de l'utilisateur
    String useChoice = 'Accept'; // Cela dépendra donc de la réponse sélectionner dans la liste des réponse d'un évènement

    if (event.choices!.containsKey(useChoice)) {
      Map<String, dynamic> effects = event.choices![useChoice]!;
      if (effects.containsKey('money') && person.bankAccounts.isNotEmpty) {
        double moneyChange = effects['money'];
        if (moneyChange > 0) {
          person.bankAccounts.first.deposit(moneyChange);
        } else {
          person.bankAccounts.first.withdraw(-moneyChange);
        }
      }
      if (effects.containsKey('health')) {
        person.health += effects['health'];
        person.health = person.health.clamp(0, 100);
      }
      if (effects.containsKey('promotion')) {
        // Handle job promotion logic
        if (effects['promotion'] == true && person.jobs.isNotEmpty) {
          Job currentJob = person.jobs.first;
          currentJob.salary *= 1.10;
          currentJob.title = "Senior " + currentJob.title;
          print("You have been promoted to ${currentJob.title} with a new salary of ${currentJob.salary}");
        }
      }
      // Ajout de plus d'effet
    }

  }
}

