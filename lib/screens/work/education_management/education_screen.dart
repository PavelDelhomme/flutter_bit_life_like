import 'dart:convert';
import 'package:bit_life_like/screens/work/education_management/books_screen.dart';
import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import 'package:flutter/services.dart';
import 'current_education_details.dart'; // Import the details screen

import '../classes/education.dart';

class EducationScreen extends StatefulWidget {
  final Person person;

  EducationScreen({required this.person});

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializePersonService();
  }

  Future<void> _initializePersonService() async {
    await personService.loadCharacters();
  }

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
    return FutureBuilder<void>(
      future: _initialization, // Initialisation du service
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error in FutureBuilder: ${snapshot.error}");
          return Center(child: Text('Error initializing service'));
        } else {
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
                      _buildCurrentEducationSection(),
                      _buildEducationHistorySection(),
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
                              builder: (context) => BooksScreen(person: widget.person),
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
      },
    );
  }

  Widget _buildCurrentEducationSection() {
    return ExpansionTile(
      title: Text("Current Education"),
      children: <Widget>[
        if (widget.person.currentEducation != null)
          Column(
            children: [
              ListTile(
                title: Text(widget.person.currentEducation!.name),
                subtitle: Text("Progress: ${widget.person.academicPerformance.toStringAsFixed(1)}%"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrentEducationDetailsScreen(person: widget.person),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Classmates"),
                subtitle: Column(
                  children: widget.person.currentEducation!.classmates.map((classmate) {
                    return Text(classmate.name);
                  }).toList(),
                ),
              ),
            ],
          )
        else
          ListTile(
            title: Text("Not enrolled in any education program."),
          ),
      ],
    );
  }

  Widget _buildEducationHistorySection() {
    return ExpansionTile(
      title: Text("Education History"),
      children: widget.person.educations.map((education) {
        return ListTile(
          title: Text(education.name),
          subtitle: Text("Completed: ${education.duration} years"),
        );
      }).toList(),
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
                    widget.person.enroll(educationLevel);
                    Navigator.of(context).pop();
                    setState(() {
                      widget.person.advanceEducation();
                    });
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
