import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import '../models/job_offre.dart';
import '../services/job_market_service.dart';

class JobMarketScreen extends StatelessWidget {
  const JobMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = GameStateService.instance.character;
    final jobs = JobMarketService.instance.getAvailableJobs(character);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Marché de l'emploi"),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final offer = jobs[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.work),
              title: Text('${offer.title} chez ${offer.companyName}'),
              subtitle: Text("Salaire : \$${offer.salary.toStringAsFixed(0)} / an"),
              onTap: () => _confirmApplication(context, offer),
            ),
          );
        },
      ),
    );
  }

  void _confirmApplication(BuildContext context, JobOffer offer) {
    final character = GameStateService.instance.character;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Postuler chez ${offer.companyName} ?"),
        content: Text("Poste : ${offer.title}\nSalaire : \$${offer.salary.toStringAsFixed(0)}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              JobMarketService.instance.applyToJob(character, offer);
              Navigator.pop(context);
              Navigator.pop(context); // retour au menu travail
            },
            child: const Text("Postuler"),
          ),
        ],
      ),
    );
  }
}
