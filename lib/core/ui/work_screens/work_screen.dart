import 'package:flutter/material.dart';
import '../../../plugin_manager.dart';
import '../../models/character.dart';

class WorkScreen extends StatelessWidget {
  final Character character;

  const WorkScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    if (!PluginManager.instance.isPluginEnabled('work_system_plugin')) {
      return const Scaffold(body: Center(child: Text("Le plugin carrière est désactivé.")));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Carrière")),
      body: character.career == null
          ? const Center(child: Text("Aucun travail actuellement."))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Métier : ${character.career!.jobTitle}', style: const TextStyle(fontSize: 18)),
          Text('Entreprise : ${character.career!.companyName}', style: const TextStyle(fontSize: 18)),
          Text('Salaire : ${character.career!.salary.toStringAsFixed(0)} \$ / an', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
