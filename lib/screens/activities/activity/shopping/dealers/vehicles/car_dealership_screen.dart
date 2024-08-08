import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../../../Classes/objects/vehicle.dart';
import '../../../../../../Classes/person.dart';

class CarDealershipScreen extends StatelessWidget {
  final Person person;

  CarDealershipScreen({required this.person});

  Future<List<Vehicle>> loadCars() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);

      List<Vehicle> vehicles = [];
      if (jsonResponse['cars'] != null) {
        vehicles.addAll(
            jsonResponse['cars'].map<Vehicle>((v) => Voiture.fromJson(v)).toList()
        );
      }
      if (jsonResponse['motorcycles'] != null) {
        vehicles.addAll(
            jsonResponse['motorcycles'].map<Vehicle>((m) => Moto.fromJson(m)).toList()
        );
      }

      return vehicles;
    } catch (e) {
      throw Exception('Failed to load vehicles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car and Motorcycle Dealerships'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: loadCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading vehicles: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No vehicles found."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = snapshot.data![index];
                return ListTile(
                  title: Text(vehicle.name),
                  subtitle: Text('Price: \$${vehicle.value.toStringAsFixed(2)} | Type: ${vehicle.type}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleDealerDetailsScreen(vehicle: vehicle)),
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
