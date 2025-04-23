import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/plugin_manager.dart';

import '../models/career.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = GameStateService.instance.character;
    final job = character.career;
    final managedBusinesses = character.businesses; // Si tu as ce champ
    final pluginItems = _getPluginExtensions(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travail & Carrière'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusTile(character),
          if (job != null) _buildCurrentJobTile(job),
          if (managedBusinesses.isNotEmpty)
            ...managedBusinesses.map(_buildBusinessTile),
          if (pluginItems.isNotEmpty) const Divider(),
          ...pluginItems,
        ],
      ),
    );
  }
  Widget _buildStatusTile(Character character) {
    String status;
    if (character.career != null) {
      status = 'Employé - ${character.career!.jobTitle}';
    } else if (character.age >= 65) {
      status = 'Retraité';
    } else if (character.businesses.isNotEmpty) {
      status = 'Entrepreneur';
    } else {
      status = 'Sans emploi';
    }

    return Card(
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('Statut professionnel'),
        subtitle: Text(status),
      ),
    );
  }

  Widget _buildCurrentJobTile(Career job) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.work),
        title: Text(job.jobTitle),
        subtitle: Text('Salaire annuel : \$${job.calculateAnnualIncome().toStringAsFixed(0)}'),
        onTap: () {
          // TODO: ouvrir écran de gestion de métier
        },
      ),
    );
  }

  Widget _buildBusinessTile(dynamic business) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.business_center),
        title: Text(business.name ?? 'Entreprise'),
        subtitle: Text('Type : ${business.type}'),
        onTap: () {
          // TODO: ouvrir menu de gestion de l’entreprise
        },
      ),
    );
  }

  List<Widget> _getPluginExtensions(BuildContext context) {
    return PluginManager.instance.getWorkMenuItems(context);
  }
}