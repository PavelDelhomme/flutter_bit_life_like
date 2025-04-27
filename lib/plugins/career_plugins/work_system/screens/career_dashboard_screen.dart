import 'package:flutter/material.dart';

import '../../../../core/models/character.dart';

class CareerDashboardScreen extends StatelessWidget {
  final Character character;

  const CareerDashboardScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final career = character.career;

    if (career == null) {
      return const Scaffold(
        body: Center(child: Text("Vous n'avez pas d'emploi actuellement.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ma Carrière')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Poste: ${career.jobTitle}', style: const TextStyle(fontSize: 18)),
          Text('Entreprise: ${career.companyName}', style: const TextStyle(fontSize: 18)),
          Text('Salaire: ${career.salary.toStringAsFixed(0)} € / an', style: const TextStyle(fontSize: 18)),
          Text('Performance: ${(career.performanceRating * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18)),
          Text('Stress: ${(career.stressLevel * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              career.askForRaise();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Demande d\'augmentation envoyée !')),
              );
            },
            child: const Text("Demander une augmentation"),
          ),
          ElevatedButton(
            onPressed: () {
              career.workHarder();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vous avez travaillé dur !')),
              );
            },
            child: const Text("Travailler plus dur"),
          ),
          ElevatedButton(
            onPressed: () {
              career.takeVacation(7);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vacances prises !')),
              );
            },
            child: const Text("Prendre une semaine de congé"),
          ),
          ElevatedButton(
            onPressed: () {
              character.career = null;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vous avez démissionné.')),
              );
              Navigator.pop(context);
            },
            child: const Text("Démissionner"),
          ),
        ],
      ),
    );
  }
}
