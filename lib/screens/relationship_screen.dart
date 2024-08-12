import 'package:flutter/material.dart';
import '../Classes/person.dart';

class RelationshipsScreen extends StatelessWidget {
  final Person person;

  RelationshipsScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relationships"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Friends"),
            subtitle: Text(person.friends.map((friend) => friend.name).join(', ')),
            onTap: () {
              // Navigate to friend management screen
            },
          ),
          ListTile(
            title: Text("Interact with Friends"),
            onTap: () {
              // Simulate interaction
              person.improveSkill("Communication", 5);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Improved communication skill through interaction."),
              ));
            },
          ),
        ],
      ),
    );
  }
}
