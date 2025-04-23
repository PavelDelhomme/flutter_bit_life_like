import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import '../models/career.dart';
import '../services/job_market_service.dart';

class JobMarketScreen extends StatelessWidget {
  const JobMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final character = GameStateService.instance.character;
    final jobs = JobMarketService.instance.getJobsForCharacter(character);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Marché de l'emploi"),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.work),
              title: Text(job.jobTitle),
              subtitle: Text("Salaire : \$${job.annualSalary.toStringAsFixed(0)} / an"),
              onTap: () => _applyToJob(context, job),
            ),
          );
        },
      ),
    );
  }

  void _applyToJob(BuildContext context, Career job) {
    final character = GameStateService.instance.character;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Postuler pour ${job.jobTitle} ?"),
        content: Text("Salaire annuel : \$${job.annualSalary.toStringAsFixed(0)}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              JobMarketService.instance.applyToJob(character, job);
              Navigator.pop(context);
              Navigator.pop(context); // Fermer l’écran
            },
            child: const Text("Postuler"),
          ),
        ],
      ),
    );
  }
}
