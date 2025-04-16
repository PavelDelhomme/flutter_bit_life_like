import 'package:bitlife_like/models/work/job.dart';
import 'package:bitlife_like/widgets/base_menu_screen.dart';
import 'package:flutter/material.dart';

class WorkScreen extends StatelessWidget {
  final List<Job> jobs;

  const WorkScreen({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return BaseMenuScreen(
      title: 'Carrière Professionnelle',
      items: jobs.map((job) => ListTile(
        title: Text(job.title),
        subtitle: Text('Entreprise: ${job.company}'),
        trailing: Text('\$${job.salary.toStringAsFixed(0)}/an'),
      )).toList(),
    );
  }
}
