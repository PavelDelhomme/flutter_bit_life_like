import 'package:bit_life_like/screens/relationship_screen.dart';
import 'package:flutter/material.dart';
import 'market_place/marketplace_menu_screen.dart';
import 'capital_screen.dart';
import 'relationships_screen.dart';
import 'activities/activities_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarketplaceMenuScreen()),
                );
              },
              child: Text('Go to Marketplace'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CapitalScreen()),
                );
              },
              child: Text('View Capital and Assets'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RelationshipsScreen()),
                );
              },
              child: Text('View Relationships'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActivitiesScreen()),
                );
              },
              child: Text('View Activities'),
            ),
          ],
        ),
      ),
    );
  }
}

