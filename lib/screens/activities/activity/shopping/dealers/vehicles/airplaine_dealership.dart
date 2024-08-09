import 'dart:developer';

import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';
import '../../../../../../services/bank/transaction_service.dart';

class AirplaineDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  AirplaineDealershipScreen({required this.person, required this.transactionService});

  Future<List<Vehicle>> loadAirplanes() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);

      List<Vehicle> vehicles = [];
      if (jsonResponse['airplanes'] != null) {
        vehicles.addAll(
            jsonResponse['airplanes']
                .map<Vehicle>((a) => Avion.fromJson(a))
                .toList()
        );
        log("Airplanes loaded successfully");
      } else {
        log("No airplaines found in JSON");
        log("In JSON : ${jsonResponse}");
      }
      return vehicles;
    } catch (e) {
      log("Failed to load vehicle in AirplaineDealerShipScreen: $e");
      throw Exception("Failed to load vehicles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane Dealerships'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: loadAirplanes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading airplaines: ${snapshot.error}");
              return Center(child: Text("Error loading airplaines"));
            }
            if (snapshot.data != null && snapshot.data!.isEmpty) {
              return Center(child: Text("No airplaines available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Vehicle avion = snapshot.data![index];
                return ListTile(
                  title: Text(avion.name),
                  subtitle: Text('Price: \$${avion.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleDealerDetailsScreen(vehicle: avion, person: person, transactionService: transactionService)),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
