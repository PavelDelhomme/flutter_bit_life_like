import 'package:flutter/material.dart';
import '../Classes/person.dart';

class PersonDetailsScreen extends StatelessWidget {
  final Person person;

  PersonDetailsScreen({required this.person});

  void _showInheritance(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Inheritance Details"),
          content: Text("You have inherited some valuable items and money."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${person.name} Details"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Health"),
            subtitle: Text("${person.health.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Happiness"),
            subtitle: Text("${person.happiness.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Intelligence"),
            subtitle: Text("${person.intelligence.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Karma"),
            subtitle: Text("${person.karma.toStringAsFixed(0)}%"),
          ),
          ListTile(
            title: Text("Stress Level"),
            subtitle: Text("${person.stressLevel.toStringAsFixed(0)}%"),
          ),
          ExpansionTile(
            title: Text("Job History"),
            children: person.jobHistory.map((job) {
              return ListTile(
                title: Text(job.title),
                subtitle: Text("Company: ${job.companyName}"),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text("Skills"),
            children: person.skills.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text("Level: ${(entry.value * 100).toStringAsFixed(1)}%"),
              );
            }).toList(),
          ),
          ListTile(
            title: Text("View Inheritance"),
            onTap: () => _showInheritance(context),
          ),
        ],
      ),
    );
  }
}
