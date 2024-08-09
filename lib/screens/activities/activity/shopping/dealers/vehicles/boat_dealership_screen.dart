import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';
import 'vehicle_details_screen.dart';

class BoatDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  BoatDealershipScreen({required this.person, required this.transactionService});

  Future<List<Vehicle>> loadBoats() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);

      List<Vehicle> vehicles = [];
      if (jsonResponse['boats'] != null) {
        vehicles.addAll(
          jsonResponse['boats'].map<Vehicle>((b) => Bateau.fromJson(b)).toList()
        );
        log("Boats loaded successfully");
      } else {
        log("No boats found in JSON");
        log("In JSON : ${jsonResponse}");
      }
      return vehicles;
    } catch (e) {
      log("Failed to load vehicle in BoatDealershipScreen: $e");
      throw Exception("Failed to load vehicles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boat Dealerships'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: loadBoats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading boats: ${snapshot.error}");
              return Center(child: Text("Error loading boats"));
            }
            if (snapshot.data != null && snapshot.data!.isEmpty) {
              return Center(child: Text("No boats available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Vehicle boat = snapshot.data![index];
                return ListTile(
                  title: Text(boat.name),
                  subtitle: Text('Price: \$${boat.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleDealerDetailsScreen(vehicle: boat, person: person, transactionService: transactionService)),
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
