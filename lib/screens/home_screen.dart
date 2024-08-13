import 'package:flutter/material.dart';
import '../Classes/person.dart';
import '../services/bank/transaction_service.dart';
import '../services/events_decision/event_service.dart';
import '../services/real_estate/real_estate.dart';
import 'life_screen/capital_screen.dart';
import 'life_screen/person_details_screen.dart';
import 'life_screen/relationship_screen.dart';
import 'work/work_screen.dart';
import 'activities/activities_screen.dart';
class HomeScreen extends StatefulWidget {
  final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;

  final List<Map<String, dynamic>> events;
  final EventService eventService;

  HomeScreen({
    required this.person,
    required this.realEstateService,
    required this.transactionService,
    required this.events,
  }) : eventService = EventService(events: events);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void agePerson() {
    setState(() {
      widget.person.ageOneYear();
    });
    // Trigger events or update state if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person, size: 50),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.person.name}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("Age: ${widget.person.age}"),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonDetailsScreen(person: widget.person),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Event and action log here',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          buildNavigationBar(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: agePerson,
              child: Text("Age One Year"),
            ),
          ),
        ],
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => WorkScreen(person: widget.person)));
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CapitalScreen(
                    person: widget.person,
                    realEstateService: widget.realEstateService,
                    transactionService: widget.transactionService,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => RelationshipsScreen(person: widget.person)));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_) => ActivitiesScreen(person: widget.person)));
              break;
          }
        },
      ),
    );
  }
}
