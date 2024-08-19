// vehicle_dealership_screen.dart
import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'airplaine_dealership_screen.dart';
import 'boat_dealership_screen.dart';
import 'car_dealership_screen.dart';
import 'moto_dealership_screen.dart';

class VehicleDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  VehicleDealershipScreen({
    required this.person,
    required this.transactionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Dealerships'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Car Dealership'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDealershipScreen(person: person, transactionService: transactionService),
              ),
            ),
          ),
          ListTile(
            title: Text('Boat Dealership'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoatDealershipScreen(person: person, transactionService: transactionService),
              ),
            ),
          ),
          ListTile(
            title: Text('Airplane Dealership'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AirplaneDealershipScreen(person: person, transactionService: transactionService),
              ),
            ),
          ),
          ListTile(
            title: Text('Motorcycle Dealership'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MotoDealershipScreen(person: person, transactionService: transactionService),
              ),
            ),
          ),
          // Add more types of dealerships as needed
        ],
      ),
    );
  }
}
