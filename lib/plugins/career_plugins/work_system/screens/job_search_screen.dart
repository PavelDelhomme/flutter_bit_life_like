import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';

import '../models/joboffer.dart';


class JobSearchScreen extends StatelessWidget {

  const JobSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = GameStateService.instance.character; // ✅ Prend le personnage courant

    // TODO: récupérer les jobs proposés (plus tard dynamique par WorkService)
    final List<JobOffer> jobOffers = [
      JobOffer(title: 'Développeur Junior', salary: 30000),
      JobOffer(title: 'Vendeur', salary: 25000),
      JobOffer(title: 'Assistant Marketing', salary: 28000),
      JobOffer(title: 'Employé Administratif', salary: 24000),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche d\'emploi')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: jobOffers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final job = jobOffers[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text('${job.salary} €/an'),
            trailing: const Icon(Icons.work),
            onTap: () {
              // Ici on pourrait postuler directement
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Candidature envoyée pour ${job.title}!')),
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

