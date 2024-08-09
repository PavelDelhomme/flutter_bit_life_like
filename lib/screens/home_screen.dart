import 'package:flutter/material.dart';
import '../Classes/person.dart';
import '../services/bank/transaction_service.dart';
import '../services/real_estate/real_estate.dart';
import 'market_place/marketplace_menu_screen.dart';
import 'capital_screen.dart';
import 'activities/activities_screen.dart';
import 'relationship_screen.dart';
import 'person_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final Person person;
  final RealEstateService realEstateService;  // Ajouter RealEstateService ici
  final TransactionService transactionService;

  HomeScreen({required this.person, required this.realEstateService, required this.transactionService});

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
                    builder: (context) => PersonDetailsScreen(person: person)),
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
            buildListTile(context, Icons.ac_unit, "Intellifence", person.intelligence),
            buildListTile(context, Icons.start, "Karma", person.karma),
            buildNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(
      BuildContext context, IconData icon, String title, double value) {
    return ListTile(
      dense: true, // Makes the ListTile more compact
      leading: Icon(icon, color: Colors.black),
      title: Text("$title: ${value.toStringAsFixed(0)}%",
          style: TextStyle(fontSize: 14)),
      trailing: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.4,
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
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: "Marketplace"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet, color: Colors.white),
              label: "Capital"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people, color: Colors.white),
              label: "Relationships"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run, color: Colors.white),
              label: "Activities"
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (_) => MarketplaceMenuScreen(person: person, transactionService: transactionService)));
              break;
            case 1:
            // Assurez-vous de passer le service RealEstateService requis
              Navigator.push(context, MaterialPageRoute(builder: (_) => CapitalScreen(person: person, realEstateService: realEstateService, transactionService: transactionService)));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => RelationshipsScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_) => ActivitiesScreen()));
              break;
          }
        },
      ),
    );
  }

}
