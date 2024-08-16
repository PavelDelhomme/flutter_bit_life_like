import 'dart:developer';

import 'package:bit_life_like/Classes/event.dart';
import 'package:bit_life_like/Classes/life_history_event.dart';
import 'package:bit_life_like/services/life_history.dart';
import 'package:flutter/material.dart';
import '../Classes/person.dart';
import '../services/bank/transaction_service.dart';
import '../services/events/events_decision/event_service.dart';
import '../services/life_state.dart';
import '../services/real_estate/real_estate.dart';
import 'life_screen/capital/capital_screen.dart';
import 'life_screen/person_details_screen.dart';
import 'life_screen/relationship_screen.dart';
import 'work/work_screen.dart';
import 'activities/activities_screen.dart';

class HomeScreen extends StatefulWidget {
  late final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final List<Event> events;
  final EventService eventService;

  HomeScreen({
    required this.person,
    required this.realEstateService,
    required this.transactionService,
    required List<Map<String, dynamic>> eventMaps,
  })  : events = eventMaps.map((eventMap) => Event.fromJson(eventMap)).toList(),
        eventService = EventService(events: eventMaps.map((eventMap) => Event.fromJson(eventMap)).toList());

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LifeHistoryEvent> eventLog = [];

  @override
  void initState() {
    super.initState();
    //_loadEvents();
    _loadLifeState();
  }

  Future<void> _loadEvents() async {
    List<LifeHistoryEvent> events = await LifeHistoryService().getEvents();
    setState(() {
      eventLog = events;
    });
  }

  Future<void> _loadLifeState() async {
    final lifeState = await LifeStateService().loadLifeState(widget.person);
    if (lifeState != null) {
      setState(() {
        widget.person = Person.fromJson(lifeState['person']);
        eventLog = (lifeState['events'] as List).map((e) => LifeHistoryEvent.fromJson(e)).toList();
      });
    } else {
      // Si aucune sauvegarde trouvée, charger les évènement normaux
      _loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Current eventLog: $eventLog"); // Ajoutez cette ligne pour vérifier l'état du log
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
              child: ListView(
                children: eventLog.map((e) => Text(e.description)).toList(),
              ),
            ),
          ),
          buildNavigationBar(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.person.ageOneYear();
                });
                log("Aged event applied");
              },
              child: Text("Age One Year"),
            ),
          ),
        ],
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
              ).then((result) {
                if (result != null && result is String) {
                  _loadEvents(); // Recharger les événements après un retour
                }
              });
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => RelationshipsScreen(person: widget.person)));
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActivitiesScreen(
                    person: widget.person,
                    eventService: widget.eventService,
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
