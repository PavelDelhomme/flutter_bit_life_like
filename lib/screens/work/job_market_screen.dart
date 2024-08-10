// job_market_screen.dart
import 'package:bit_life_like/screens/work/classes/job.dart';
import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../services/work/jobmarket_service.dart';

class JobMarketScreen extends StatelessWidget {
  final Person person;
  final JobMarketService jobMarketService = JobMarketService();

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
                Job job = jobMarketService.availableJobs[index];
                return ListTile(
                  title: Text(job.jobTitle),
                  subtitle: Text(
                      'Company: ${job.employerName}, Salary: \$${job.monthlySalary}/month'),
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

  void _showApplyDialog(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply for ${job.jobTitle}"),
          content: Text(
              "Do you want to apply for this job at ${job.employerName}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Apply"),
              onPressed: () {
                // Check eligibility and apply
                if (_canApplyForJob(person, job)) {
                  person.jobs.add(job as Job);
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

  bool _canApplyForJob(Person person, Job job) {
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
