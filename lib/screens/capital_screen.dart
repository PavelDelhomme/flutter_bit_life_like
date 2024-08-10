// capital_screen.dart
import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';
import '../services/bank/transaction_service.dart';
import 'capitals_management/antiques/my_antiques_screen.dart';
import 'capitals_management/banks/bank_account_screen.dart';
import 'capitals_management/electronics/electronics_screen.dart';
import 'capitals_management/jewelrys/my_jewelrys_screen.dart';
import 'capitals_management/real_estates/my_real_estates_screen.dart';
import 'capitals_management/vehicles/vehicules_screen.dart';
import 'market_place/marketplace_screen.dart';

class CapitalScreen extends StatelessWidget {
  final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;

  CapitalScreen({required this.person, required this.realEstateService, required this.transactionService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Capital and Assets'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Bank Accounts"),
            children: <Widget>[
              ListTile(
                title: Text("View Accounts"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BankAccountScreen(person: person)));
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Investments"),
            children: <Widget>[
              ListTile(
                title: Text("Stock Market"),
                onTap: () {
                  // Navigate to Stock Market Screen
                },
              ),
              ListTile(
                title: Text("Cryptocurrencies"),
                onTap: () {
                  // Navigate to Cryptocurrency Investment Screen
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Properties"),
            children: <Widget>[
              ListTile(
                title: Text("Real Estate"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyRealEstatesScreen(person: person, realEstateService: realEstateService, transactionService: transactionService,)));
                },
              ),
              ListTile(
                title: Text("Vehicles"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyVehiclesScreen(person: person)));
                },
              ),
              ListTile(
                title: Text("Jewelrys"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyJewelrysScreen(person: person)));
                },
              ),
              ListTile(
                title: Text("Electronics"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyElectronicsScreen(electronics: person.electronics)));
                },
              ),
              ListTile(
                title: Text("Antiques"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyAntiquesScreen(person: person)));
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: buildNavigationBar(context),
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Assets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Marketplace',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
          // Already on the Assets screen, do nothing or navigate to home
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarketplaceScreen(person: person),
              ),
            );
            break;
        }
      },
    );
  }
}
