import 'package:flutter/material.dart';

import '../../services/loan_service.dart';
import '../../services/real_estate/real_estate.dart';
import '../../services/bank/transaction_service.dart';
import '../dealers/boat_dealership_screen.dart';
import '../dealers/car_dealership_screen.dart';
import '../dealers/enchere_house_screen.dart';
import '../dealers/jewelry_market_screen.dart';
import '../dealers/real_estate_dealership_screen.dart';
import '../dealers/seconde_main_market_screen.dart';

class MarketplaceMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace Menu'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Text('Car Dealerships'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarDealershipScreen()))),
          ListTile(
              title: Text('Boat Dealerships'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoatDealershipScreen()))),
          ListTile(
              title: Text('Real Estate Market'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RealEstateMarketScreen(
                          realEstateService: RealEstateService(),
                          loanService: LoanService(),
                          transactionService: TransactionService())))),
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
