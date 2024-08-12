import 'package:flutter/material.dart';
import '../Classes/person.dart';

class PersonDetailsScreen extends StatelessWidget {
  final Person person;

  PersonDetailsScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${person.name} Details"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Current Jobs"),
            subtitle: Text(person.jobs.map((job) => job.title).join(', ')),
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
                subtitle: Text("Level: ${entry.value}"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
