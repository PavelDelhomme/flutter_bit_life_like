// job_market_screen.dart
import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../services/work/career_service.dart';
import 'jobmarket.dart';

class JobMarketScreen extends StatelessWidget {
  final Person person;
  final JobMarket jobMarket = JobMarket(availableJobs: []);  // Initialize with available jobs

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
          var job = jobMarket.availableJobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text("Company: ${job.companyName}, Salary: \$${job.salary}"),
            onTap: () {
              jobMarket.applyForJob(person, job);
              Navigator.pop(context);  // Go back to the previous screen
            },
          );
        },
      ),
    );
  }
}
