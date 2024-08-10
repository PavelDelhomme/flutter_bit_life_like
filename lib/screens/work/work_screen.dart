import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import 'business_management_screen.dart';
import 'education_screen.dart';
import 'job_market_screen.dart';

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
          ListTile(
            title: Text("Manage Current Jobs"),
            onTap: () {
              // Navigate to current job management screen
            },
          ),
          ListTile(
            title: Text("Job Market"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobMarketScreen(
                    person: person,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text("Business Management"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusinessManagementScreen(
                    person: person,
                  ),
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
                  builder: (context) => EducationScreen(
                    person: person,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
