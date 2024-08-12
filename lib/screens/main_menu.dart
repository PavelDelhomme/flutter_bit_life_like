import 'package:bit_life_like/screens/person_details_screen.dart';
import 'package:bit_life_like/screens/relationship_screen.dart';
import 'package:bit_life_like/screens/work/work_screen.dart';
import 'package:bit_life_like/services/events_decision/event_service.dart';
import 'package:flutter/material.dart';
import 'activities/activities_screen.dart';
import 'capital_screen.dart';
import 'home_screen.dart';
import '../services/real_estate/real_estate.dart';
import '../services/bank/transaction_service.dart';
import '../Classes/person.dart';

class MainMenu extends StatelessWidget {
  final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final EventService eventService = EventService(events: []);

  MainMenu({
    required this.person,
    required this.realEstateService,
    required this.transactionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
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
          )
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
            buildListTile(context, Icons.warning, "Stress", person.stressLevel), // Stress level
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
          style: TextStyle(fontSize: 14)),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(width: 10),
            Text('${value.toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => RelationshipsScreen(person: person)));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_) => ActivitiesScreen(person: person)));
              break;
          }
        },
      ),
    );
  }
}
