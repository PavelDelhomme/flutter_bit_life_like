import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import '../company_management/business_management_screen.dart';
import '../jobs_management/job_management_screen.dart';
import '../jobs_management/job_market_screen.dart';
import 'education_screen.dart';

class WorkAndEducationManagementScreen extends StatelessWidget {
  final Person person;

  WorkAndEducationManagementScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work and Education Management'),
      ),
      body: ListView(
        children: <Widget>[
          // Affiche les options du marché du travail uniquement si la personne a au moins 16 ans
          if (person.age >= 16)
            ListTile(
              title: Text("Current Jobs"),
              subtitle: Text("Manage your jobs"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobManagementScreen(person: person),
                  ),
                );
              },
            ),
          if (person.age >= 16)
            ListTile(
              title: Text("Job Market"),
              subtitle: Text("Find new jobs"),
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
              subtitle: Text("Manage your business"),
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
            title: Text("Current Education"),
            subtitle: Text("Manage your education"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationScreen(person: person),
                ),
              );
            },
          ),
          ListTile(
            title: Text("Study Harder"),
            onTap: () {
              person.academicPerformance += 0.1;
              person.stressLevel += 0.05;
              print("Stress Level: ${person.stressLevel}, Academic Performance: ${person.academicPerformance}");
            },
          ),
        ],
      ),
    );
  }
}
