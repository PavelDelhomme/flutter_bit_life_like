import 'package:flutter/material.dart';
import '../Classes/person.dart';

class PersonDetailsScreen extends StatelessWidget {
  final Person person;

  PersonDetailsScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of ${person.name}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${person.name}"),
            Text("Health: ${person.health}"),
            Text("Happiness: ${person.happiness}"),
            Text("Intelligence: ${person.intelligence}"),
            Text("Karma: ${person.karma}"),
            // Ajoutez plus de détails selon les besoins
          ],
        ),
      ),
    );
  }
}
