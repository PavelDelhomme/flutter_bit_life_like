import 'dart:developer';

import 'package:bit_life_like/screens/activities/activity/shopping/dealers/reale_estate/real_estate_classic_screen.dart';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/airplaine_dealership.dart';
import 'package:flutter/material.dart';

import '../../Classes/person.dart';
import '../../services/real_estate/real_estate.dart';
import '../../services/bank/transaction_service.dart';
import '../activities/activity/shopping/dealers/jewelry_market_screen.dart';
import '../activities/activity/shopping/dealers/reale_estate/real_estate_dealership_screen.dart';
import '../activities/activity/shopping/dealers/reale_estate/real_estate_exotic_screen.dart';
import '../activities/activity/shopping/dealers/seconde_main_market_screen.dart';
import '../activities/activity/shopping/dealers/vehicles/boat_dealership_screen.dart';
import '../activities/activity/shopping/dealers/vehicles/car_dealership_screen.dart';
import '../activities/activity/shopping/real_estate/enchere_house_screen.dart';

class MarketplaceMenuScreen extends StatelessWidget {
  late final Person person;


  MarketplaceMenuScreen({required this.person}); // Add constructor to take person

  @override
  Widget build(BuildContext context) {
    log("marketplace_menu_screen.dart : person : ${person}");
    log("marketplace_menu_screen.dart : person name : ${person.name}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace Menu'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Text('Vendeur de voiture'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarDealershipScreen(person: person)))),
          ListTile(
              title: Text('Vendeur de bateaux'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoatDealershipScreen(person: person)))),
          ListTile(
              title: Text('Vendeur d\'avion'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AirplaineDealershipScreen(person: person)))),
          ListTile(
              title: Text('Marché Immobilier'),
              subtitle: Text('Toucher pour sélectionner la catégorie de biens'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Catégorie'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RealEstateClassicScreen(
                                        realEstateService: RealEstateService(),
                                        transactionService: TransactionService(),
                                        person: person)),
                              );
                            },
                            child: const Text('Classique'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RealEstateExoticScreen(
                                        realEstateService: RealEstateService(),
                                        transactionService: TransactionService(),
                                        person: person)),
                              );
                            },
                            child: const Text('Exotique'),
                          ),
                        ],
                      );
                    });
              }),
          ListTile(
              title: Text('Auction House'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnchereHouseScreen()))),
          ListTile(
              title: Text('Second Hand Market'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecondHandMarketScreen()))),
          ListTile(
              title: Text('Jewelry Market'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JewelryMarketScreen()))),
        ],
      ),
    );
  }
}
