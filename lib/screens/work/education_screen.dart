// education_screen.dart
import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../screens/work/classes/education.dart';

class EducationScreen extends StatelessWidget {
  final Person person;

  EducationScreen({required this.person});

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
                  subtitle: Text("Progress: ${person.academicPerformance}%"),
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
              _showNewEducationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showNewEducationDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController costController = TextEditingController();
    TextEditingController minAgeController = TextEditingController();
    TextEditingController maxAgeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enroll in New Education"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Education Level Name"),
              ),
              TextField(
                controller: costController,
                decoration: InputDecoration(labelText: "Cost"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: minAgeController,
                decoration: InputDecoration(labelText: "Minimum Age"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: maxAgeController,
                decoration: InputDecoration(labelText: "Maximum Age"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Enroll"),
              onPressed: () {
                String name = nameController.text;
                double cost = double.parse(costController.text);
                int minAge = int.parse(minAgeController.text);
                int maxAge = int.parse(maxAgeController.text);

                person.enroll(EducationLevel(name: name, cost: cost, minAge: minAge, maxAge: maxAge));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
