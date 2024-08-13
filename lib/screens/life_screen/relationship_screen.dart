import 'package:bit_life_like/Classes/activity.dart';
import 'package:bit_life_like/services/relation.dart';
import 'package:flutter/material.dart';
import '../../Classes/person.dart';

class RelationshipsScreen extends StatefulWidget {
  final RelationService relationService = RelationService();
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
              _showFamilyMemberDetails(context, familyMember);
            },
          ),
          _buildRelationshipSection(
            context,
            title: "Friends",
            people: widget.person.friends,
            onTap: (friend) {
              _showFriendDetails(context, friend);
            },
          ),
          _buildRelationshipSection(
            context,
            title: "Colleagues",
            people: widget.person.jobs.expand((job) => job.colleagues).toList(),
            onTap: (colleague) {
              _showColleagueDetails(context, colleague);
            },
          ),
          ListTile(
            title: Text("Interact with Friends"),
            onTap: () {
              widget.person.improveSkill("Communication", 5);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Improved communication skill through interaction."),
              ));
              setState(() {});
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
          subtitle: Text("Age: ${person.age}, Country: ${person.country}"),
          onTap: () => onTap(person),
        );
      }).toList(),
    );
  }

  void _showFamilyMemberDetails(BuildContext context, Person familyMember) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(familyMember.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Age: ${familyMember.age}"),
              Text("Gender: ${familyMember.gender}"),
              Text("Country: ${familyMember.country}"),
              Text("Bank Accounts:"),
              ...familyMember.bankAccounts.map((account) => Text(
                  "${account.bankName} - ${account.accountType}: \$${account.balance.toStringAsFixed(2)}")),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }


  void _showFriendDetails(BuildContext context, Person friend) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(friend.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Age: ${friend.age}"),
              Text("Gender: ${friend.gender}"),
              Text("Country: ${friend.country}"),
              // Add more details if necessary
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showColleagueDetails(BuildContext context, Person colleague) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(colleague.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Age : ${colleague.age}"),
              Text("Gender : ${colleague.gender}"),
              Text("Country : ${colleague.country}"),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("Collaborate"),
                onPressed: () {
                  widget.person.improveSkill("Collectif", 0.5);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Collaborate with ${colleague.name}, teamwork improved !"),
                  ));
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
  }
  void _showInteractionOptions(BuildContext context, Person target) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Interact with ${target.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: activities.map((activity) {
              return ElevatedButton(
                child: Text(activity.name),
                onPressed: () {
                  widget.person.performActivity(target, activity);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
