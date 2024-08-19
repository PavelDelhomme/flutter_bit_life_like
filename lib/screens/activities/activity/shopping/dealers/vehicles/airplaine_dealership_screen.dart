import 'dart:developer';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicles/avion.dart';
import '../../../../../../services/bank/transaction_service.dart';

class AirplaneDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  AirplaneDealershipScreen({required this.person, required this.transactionService});

  Future<List<Avion>> loadAirplanes() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      List<dynamic> jsonResponse = json.decode(jsonString)['airplanes'];

      List<Avion> airplanes = jsonResponse.map((a) => Avion.fromJson(a)).toList();
      log("Airplanes loaded successfully");
      return airplanes;
    } catch (e) {
      log("Failed to load airplanes: $e");
      throw Exception("Failed to load airplanes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane Dealerships'),
      ),
      body: FutureBuilder<List<Avion>>(
        future: loadAirplanes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading airplanes: ${snapshot.error}");
              return Center(child: Text("Error loading airplanes"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No airplanes available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Avion airplane = snapshot.data![index];
                return ListTile(
                  title: Text(airplane.name),
                  subtitle: Text('Price: \$${airplane.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleDealerDetailsScreen(
                              vehicle: airplane,
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
