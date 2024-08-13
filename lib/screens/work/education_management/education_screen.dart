import 'dart:convert';
import 'package:bit_life_like/screens/work/education_management/books_screen.dart';
import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import 'package:flutter/services.dart';

import '../classes/education.dart';

class EducationScreen extends StatelessWidget {
  final Person person;

  EducationScreen({required this.person});

  Future<List<EducationLevel>> _loadEducationLevels() async {
    try {
      String data = await rootBundle.loadString('assets/educations.json');
      Map<String, dynamic> jsonResult = jsonDecode(data);

      List<EducationLevel> educationLevels = [];

      jsonResult['educations'].forEach((level, schools) {
        for (var school in schools) {
          educationLevels.add(EducationLevel.fromJson(school));
        }
      });

      return educationLevels;
    } catch (e) {
      print("Error loading education levels: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EducationLevel>>(
      future: _loadEducationLevels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error in FutureBuilder: ${snapshot.error}");
          return Center(child: Text('Error loading education levels'));
        } else {
          final educationLevels = snapshot.data ?? [];
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
                  children: person.educations.map((education) {
                    return ListTile(
                      title: Text(education.name),
                      subtitle: Text("Completed: ${education.duration} years"),
                    );
                  }).toList(),
                ),
                ListTile(
                  title: Text("Enroll in New Education"),
                  onTap: () {
                    _showEducationSelectionDialog(context, educationLevels);
                  },
                ),
                ListTile(
                  title: Text("Read Books"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BooksScreen(person: person),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showEducationSelectionDialog(BuildContext context, List<EducationLevel> educationLevels) {
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
                    person.advanceEducation();
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
