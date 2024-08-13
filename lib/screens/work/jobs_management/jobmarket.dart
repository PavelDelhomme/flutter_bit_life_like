// job_market_screen.dart
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
                // Generate a random number of colleagues between 3 and 30
                int numberOfColleagues = Random().nextInt(50) + 3;

                // Create a new Job instance for the person

                JobMarket jobMarket = JobMarket(availableJobs: jobMarketService.availableJobs);
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
