import 'package:flutter/material.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/work_service.dart';
import 'package:bitlife_like/plugins/career_plugins/work_system/services/job_offer_service.dart';
import '../models/joboffer.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  List<JobOffer> jobOffers = [];

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  void _loadOffers() {
    jobOffers = JobOfferService().generateJobOffers(GameStateService.instance.character);
  }

  @override
  Widget build(BuildContext context) {
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
            subtitle: Text('${job.salary.toStringAsFixed(0)} €/an - ${job.company}'),
            trailing: const Icon(Icons.work),
            onTap: () {
              WorkService().applyForJob(GameStateService.instance.character, job);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Candidature envoyée pour ${job.title} chez ${job.company}!')),
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
