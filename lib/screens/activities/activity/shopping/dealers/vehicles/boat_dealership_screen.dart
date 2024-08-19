import 'dart:developer';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicles/bateau.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';

class BoatDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  BoatDealershipScreen({required this.person, required this.transactionService});

  Future<List<Bateau>> loadBoats() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      List<dynamic> jsonResponse = json.decode(jsonString)['boats'];

      List<Bateau> boats = jsonResponse.map((b) => Bateau.fromJson(b)).toList();
      log("Boats loaded successfully");
      return boats;
    } catch (e) {
      log("Failed to load boats: $e");
      throw Exception("Failed to load boats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boat Dealerships'),
      ),
      body: FutureBuilder<List<Bateau>>(
        future: loadBoats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading boats: ${snapshot.error}");
              return Center(child: Text("Error loading boats"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No boats available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Bateau boat = snapshot.data![index];
                return ListTile(
                  title: Text(boat.name),
                  subtitle: Text('Price: \$${boat.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleDealerDetailsScreen(
                              vehicle: boat,
                              person: person,
                              transactionService: transactionService
                          )
                      ),
                    );
                  },
                );
              },
            );
          } else {
            log("Loading boats...");
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
