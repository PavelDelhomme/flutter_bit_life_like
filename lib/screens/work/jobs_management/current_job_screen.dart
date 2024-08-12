// current_job_screen.dart
import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import '../classes/job.dart';

class CurrentJobScreen extends StatelessWidget {
  final Person person;

  CurrentJobScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Current Jobs'),
      ),
      body: ListView.builder(
        itemCount: person.jobs.length,
        itemBuilder: (context, index) {
          Job job = person.jobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text("Company: ${job.companyName}, Salary: \$${job.salary}/hour"),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                _showJobDetailsDialog(context, job);
              },
            ),
          );
        },
      ),
    );
  }

  void _showJobDetailsDialog(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(job.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Company: ${job.companyName}"),
              Text("Salary: \$${job.salary}/hour"),
              Text("Hours per week: ${job.hoursPerWeek}"),
              Text("Stress Level: ${job.stressLevel}"),
              SizedBox(height: 10),
              TextButton(
                child: Text("Work Extra Hours"),
                onPressed: () {
                  person.workExtraHours(job, 5); // Example of extra hours
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Worked extra hours, stress level increased")),
                  );
                },
              ),
              TextButton(
                child: Text("Request Promotion"),
                onPressed: () {
                  // Implement promotion logic
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
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
