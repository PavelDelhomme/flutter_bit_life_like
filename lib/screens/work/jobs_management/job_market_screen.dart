import 'dart:math';
import 'package:bit_life_like/screens/work/classes/job.dart';
import 'package:bit_life_like/services/jobservice.dart';
import 'package:flutter/material.dart';
import '../../../Classes/person.dart';

class JobMarketScreen extends StatelessWidget {
  final Person person;
  final JobService jobService = JobService(); // Utilisation de JobService

  JobMarketScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    // Charger les emplois disponibles
    List<Job> availableJobs = jobService.loadJobs();

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Market'),
      ),
      body: ListView.builder(
        itemCount: availableJobs.length,
        itemBuilder: (context, index) {
          Job job = availableJobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text('Company: ${job.companyName}, Salary: \$${job.salary}/year'),
            onTap: () {
              _showApplyDialog(context, job);
            },
          );
        },
      ),
    );
  }

  void _showApplyDialog(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply for ${job.title}"),
          content: Text("Do you want to apply for this job at ${job.companyName}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Apply"),
              onPressed: () {
                // Appliquer pour le job et générer les collègues
                jobService.applyForJob(person, job);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
