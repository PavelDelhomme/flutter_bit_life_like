import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import 'company_management/business_management_screen.dart';
import 'education_management/education_screen.dart';
import 'jobs_management/job_market_screen.dart';
import 'jobs_management/current_job_screen.dart'; // Import the current job screen


class WorkScreen extends StatelessWidget {
  final Person person;

  WorkScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work & Education'),
      ),
      body: ListView(
        children: <Widget>[
          if (person.age >= 16) // Affiche cette option seulement si la personne a au moins 16 ans
            ListTile(
              title: Text("Manage Current Jobs"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurrentJobScreen(person: person),
                  ),
                );
              },
            ),
          if (person.age >= 16)
            ListTile(
              title: Text("Job Market"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobMarketScreen(person: person),
                  ),
                );
              },
            ),
          if (person.businesses.isNotEmpty)
            ListTile(
              title: Text("Business Management"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessManagementScreen(person: person),
                  ),
                );
              },
            ),
          ListTile(
            title: Text("Education"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationScreen(person: person),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
