import 'dart:math';

import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import '../../../services/work/jobmarket_service.dart';
import '../classes/jobmarket.dart';

class JobMarketScreen extends StatelessWidget {
  final Person person;
  final JobMarketService jobMarketService = JobMarketService();

  JobMarketScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    if (person.age < 16) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Job Market"),
        ),
        body: Center(
          child: Text("You must be at least 116 years old to access the job market."),
        ),
      );
    }
    return FutureBuilder(
      future: jobMarketService.loadJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading jobs"));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Job Market"),
            ),
            body: ListView.builder(
              itemCount: jobMarketService.availableJobs.length,
              itemBuilder: (context, index) {
                MarketJob job = jobMarketService.availableJobs[index];
                return ListTile(
                  title: Text(job.jobTitle),
                  subtitle: Text("Company: ${job.employerName}, Salary: \$${job.monthlySalary}/month"),
                  onTap: () {
                    _showApplyDialog(context, job);
                  },
                );
              },
            ),
          );
        }
      },
    );
  }

  void _showApplyDialog(BuildContext context, MarketJob job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply for ${job.jobTitle}"),
          content: Text("Do you want to apply for this job at ${job.employerName}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Apply"),
              onPressed: () {
                // Generate a random number of colleagues between 3 and 50
                int numberOfColleagues = Random().nextInt(50) + 3;

                // Simulate job application
                JobMarket jobMarket = JobMarket(availableJobs: jobMarketService.availableJobs);
                bool applicationSuccess = jobMarket.applyForJob(person, job);

                // Close the dialog
                Navigator.of(context).pop();

                // Provide feedback to the user
                if (applicationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You successfully applied for ${job.jobTitle} at ${job.employerName}!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Application for ${job.jobTitle} at ${job.employerName} failed."),
                      backgroundColor: Colors.red,
                    ),
                  );
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
}
