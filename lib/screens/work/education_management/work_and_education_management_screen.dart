import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import '../jobs_management/job_management_screen.dart';
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
          ListTile(
            title: Text("Work Harder"),
            onTap: () {
              person.stressLevel += 0.1;
              person.academicPerformance += 0.05;
              print("Stress Level: ${person.stressLevel}, Academic Performance: ${person.academicPerformance}");
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
