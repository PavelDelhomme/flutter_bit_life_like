import 'package:bit_life_like/Classes/activity.dart';
import 'package:bit_life_like/services/relation.dart';
import 'package:flutter/material.dart';
import '../../Classes/person.dart';

class RelationshipsScreen extends StatefulWidget {
  final Person person;

  RelationshipsScreen({required this.person});

  @override
  _RelationshipsScreenState createState() => _RelationshipsScreenState();
}

class _RelationshipsScreenState extends State<RelationshipsScreen> {
  final RelationService relationService = RelationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relationships"),
      ),
      body: ListView(
        children: <Widget>[
          _buildRelationshipSection(
            context,
            title: "Family",
            people: widget.person.parents + widget.person.partners,
            onTap: (familyMember) {
              _showPersonDetails(context, familyMember);
            },
          ),
          _buildRelationshipSection(
            context,
            title: "Friends",
            people: widget.person.friends,
            onTap: (friend) {
              _showPersonDetails(context, friend);
            },
          ),
          _buildRelationshipSection(
            context,
            title: "Colleagues",
            people: widget.person.jobs.expand((job) => job.colleagues).toList(),
            onTap: (colleague) {
              _showPersonDetails(context, colleague);
            },
          ),
          ListTile(
            title: Text("Perform Solo Activities"),
            onTap: () {
              _showSoloActivityOptions(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipSection(BuildContext context,
      {required String title, required List<Person> people, required Function(Person) onTap}) {
    return ExpansionTile(
      title: Text(title),
      children: people.map((person) {
        return ListTile(
          title: Text(person.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Age: ${person.age}, Country: ${person.country}"),
              _buildRelationshipProgress(person),
            ],
          ),
          onTap: () => onTap(person),
        );
      }).toList(),
    );
  }

  Widget _buildRelationshipProgress(Person person) {
    double quality = widget.person.relationships[person.id]?.quality ?? 0.0;
    return Column(
      children: [
        LinearProgressIndicator(
          value: quality / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            quality > 70 ? Colors.green : (quality > 40 ? Colors.orange : Colors.red),
          ),
        ),
        Text(
          "Relationship Quality: ${quality.toStringAsFixed(1)}%",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
  void _showPersonDetails(BuildContext context, Person person) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Age: ${person.age}, Country: ${person.country}"),
                SizedBox(height: 16),
                Text(
                  "Interactions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: activities.where((activity) => activity.relationImpact != 0).map((activity) {
                    return ElevatedButton(
                      child: Text(activity.name),
                      onPressed: () {
                        widget.person.performActivity(context, person, activity);
                        Navigator.of(context).pop();  // Fermer le modal
                        setState(() {});  // Rafraîchir l'UI
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSoloActivityOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Perform Solo Activities"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: activities.where((activity) => activity.relationImpact == 0).map((activity) {
                return ElevatedButton(
                  child: Text(activity.name),
                  onPressed: () {
                    widget.person.performActivity(context, null, activity);
                    Navigator.of(context).pop();  // Fermer la boîte de dialogue
                    setState(() {});  // Rafraîchir l'UI
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
