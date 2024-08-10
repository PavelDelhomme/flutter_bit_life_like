// job_market_screen.dart
import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import 'package:bit_life_like/screens/work/classes/job.dart' as job_class;
import 'package:bit_life_like/services/work/jobmarket_service.dart' as job_service;



class JobMarketScreen extends StatelessWidget {
  final Person person;
  final job_service.JobMarketService jobMarketService = job_service.JobMarketService();

  JobMarketScreen({required this.person});

  @override
  void initState() {
    jobMarketService.loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Market'),
      ),
      body: FutureBuilder(
        future: jobMarketService.loadJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading jobs'));
          } else {
            return ListView.builder(
              itemCount: jobMarketService.availableJobs.length,
              itemBuilder: (context, index) {
                job_class.Job job = jobMarketService.availableJobs[index] as job_class.Job;
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(
                      'Company: ${job.companyName}, Salary: \$${job.salary}/hours'),
                  onTap: () {
                    _showApplyDialog(context, job);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showApplyDialog(BuildContext context, job_class.Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply for ${job.title}"),
          content: Text(
              "Do you want to apply for this job at ${job.companyName}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Apply"),
              onPressed: () {
                // Check eligibility and apply
                if (_canApplyForJob(person, job)) {
                  person.jobs.add(job as job_class.Job);
                  Navigator.of(context).pop();
                  _showSuccessDialog(context, "You have applied successfully!");
                } else {
                  Navigator.of(context).pop();
                  _showErrorDialog(context, "You do not meet the job requirements.");
                }
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

  bool _canApplyForJob(Person person, job_class.Job job) {
    bool hasRequiredEducation = person.educationHistory.any(
            (education) => education.name == job.educationRequired);
    bool hasRequiredExperience = person.jobs.length >= job.yearsRequired;

    return hasRequiredEducation && hasRequiredExperience;
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
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
