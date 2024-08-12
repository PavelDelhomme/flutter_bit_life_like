// job_management_screen.dart
import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import '../classes/job.dart';
import 'job_market_screen.dart';

class JobManagementScreen extends StatelessWidget {
  final Person person;

  JobManagementScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Jobs'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Current Jobs"),
            children: person.jobs.map((job) {
              return ListTile(
                title: Text(job.title),
                subtitle: Text("Company: ${job.companyName}, Salary: \$${job.salary}/hour"),
                onTap: () {
                  // Show more details about the job or provide actions like resign
                },
              );
            }).toList(),
          ),
          ListTile(
            title: Text("Job Market"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => JobMarketScreen(person: person)));
            },
          ),
        ],
      ),
    );
  }
}
