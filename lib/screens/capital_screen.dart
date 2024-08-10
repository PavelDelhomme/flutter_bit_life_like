import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart'; // Import RealEstateService

import '../services/bank/transaction_service.dart';
import 'capitals_management/arts/arts_screen.dart';
import 'capitals_management/banks/bank_account_screen.dart';
import 'capitals_management/electronics/electronics_screen.dart';
import 'capitals_management/jewelrys/jewelrys_screen.dart';
import 'capitals_management/real_estates/my_real_estates_screen.dart';
import 'capitals_management/vehicles/vehicules_screen.dart';

class CapitalScreen extends StatelessWidget {
  final Person person;
  final RealEstateService realEstateService; // Add RealEstateService
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
                title: Text("Arts"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyArtsScreen(person: person)));
                },
              )
            ],
          ),
        ],
      )
    );
  }
}
