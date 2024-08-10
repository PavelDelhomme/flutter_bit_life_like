// job_market_screen.dart
import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../screens/work/classes/job.dart';
import 'classes/jobmarket.dart';

class JobMarketScreen extends StatelessWidget {
  final Person person;
  final JobMarket jobMarket = JobMarket(availableJobs: [
    // Sample jobs
    Job(
      title: 'Software Developer',
      country: 'USA',
      salary: 30.0,
      hoursPerWeek: 40,
      companyName: 'TechCorp',
      isFullTime: true,
    ),
    Job(
      title: 'Data Analyst',
      country: 'USA',
      salary: 28.0,
      hoursPerWeek: 35,
      companyName: 'DataCorp',
      isFullTime: true,
    ),
  ]);

  JobMarketScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Market'),
      ),
      body: ListView.builder(
        itemCount: jobMarket.availableJobs.length,
        itemBuilder: (context, index) {
          Job job = jobMarket.availableJobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text('Company: ${job.companyName}, Salary: \$${job.salary}/hour'),
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
                jobMarket.applyForJob(person, job);
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
