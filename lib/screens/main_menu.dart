import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';
import 'life_screen/person_details_screen.dart';
import 'life_screen/relationship_screen.dart';
import 'work/work_screen.dart';
import 'life_screen/capital_screen.dart';
import 'activities/activities_screen.dart';
import 'work/jobs_management/job_management_screen.dart'; // Import job management screen
import 'work/education_management/education_screen.dart'; // Import education screen

class MainMenu extends StatelessWidget {
  final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;

  MainMenu({
    required this.person,
    required this.realEstateService,
    required this.transactionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menus'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonDetailsScreen(person: person),
                ),
              );
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildListTile(context, Icons.favorite, "Health", person.health),
            buildListTile(context, Icons.face, 'Happiness', person.happiness),
            buildListTile(context, Icons.ac_unit, "Intelligence", person.intelligence),
            buildListTile(context, Icons.star, "Karma", person.karma),
            buildListTile(context, Icons.warning, "Stress", person.stressLevel), // Add stress level
            buildNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context, IconData icon, String title, double value) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.black),
      title: Text("$title: ${value.toStringAsFixed(0)}%",
          style: const TextStyle(fontSize: 14)),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(width: 10),
            Text('${value.toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.black54],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work, color: Colors.white),
            label: "Work",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet, color: Colors.white),
            label: "Capital",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Colors.white),
            label: "Relationships",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run, color: Colors.white),
            label: "Activities",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.white),
            label: "Education",
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (_) => WorkScreen(person: person)));
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CapitalScreen(
                    person: person,
                    realEstateService: realEstateService,
                    transactionService: transactionService,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => RelationshipsScreen(person: person,)));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_) => ActivitiesScreen(person: person,)));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (_) => EducationScreen(person: person)));
              break;
          }
        },
      ),
    );
  }
}
