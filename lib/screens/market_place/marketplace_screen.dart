// marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';

import '../activities/activity/shopping/dealers/jewelry/jewelry_market_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  final Person person;

  MarketplaceScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Antiques Market"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AntiquesMarketScreen(person: person)));
            },
          ),
          ListTile(
            title: Text("Electronics Market"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ElectronicsMarketScreen(person: person)));
            },
          ),
          ListTile(
            title: Text("Jewelry Market"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => JewelryMarketScreen(person: person, transactionService: null,)));
            },
          ),
          ListTile(
            title: Text("Real Estate Market"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RealEstateMarketScreen(person: person)));
            },
          ),
          ListTile(
            title: Text("Vehicle Market"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleMarketScreen(person: person)));
            },
          ),
        ],
      ),
    );
  }
}
