import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../screens/work/classes/education.dart';

class EducationScreen extends StatelessWidget {
  final Person person;

  EducationScreen({required this.person});

  final List<EducationLevel> educationLevels = [
    EducationLevel(
      name: 'High School Diploma',
      minAge: 14,
      maxAge: 18,
      cost: 1000,
      specializations: ['General'],
    ),
    EducationLevel(
      name: 'Bachelor\'s Degree',
      minAge: 18,
      maxAge: 22,
      cost: 5000,
      specializations: ['Science', 'Arts', 'Business'],
    ),
    EducationLevel(
      name: 'Master\'s Degree',
      minAge: 22,
      maxAge: 25,
      cost: 10000,
      specializations: ['Engineering', 'Management'],
    ),
    EducationLevel(
      name: 'PhD',
      minAge: 25,
      maxAge: 30,
      cost: 15000,
      specializations: ['Research', 'Development'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Education'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Current Education"),
            children: <Widget>[
              if (person.currentEducation != null)
                ListTile(
                  title: Text(person.currentEducation!.name),
                  subtitle: Text("Progress: ${person.academicPerformance.toStringAsFixed(1)}%"),
                )
              else
                ListTile(
                  title: Text("Not enrolled in any education program."),
                ),
            ],
          ),
          ExpansionTile(
            title: Text("Education History"),
            children: person.educationHistory.map((education) {
              return ListTile(
                title: Text(education.name),
                subtitle: Text("Completed: ${education.maxAge - education.minAge} years"),
              );
            }).toList(),
          ),
          ListTile(
            title: Text("Enroll in New Education"),
            onTap: () {
              _showEducationSelectionDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEducationSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Education Level"),
          content: SingleChildScrollView(
            child: ListBody(
              children: educationLevels.map((educationLevel) {
                return ListTile(
                  title: Text(educationLevel.name),
                  subtitle: Text("Cost: \$${educationLevel.cost}"),
                  onTap: () {
                    person.enroll(educationLevel);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
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
