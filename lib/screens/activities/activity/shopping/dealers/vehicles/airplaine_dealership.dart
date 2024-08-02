import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';

class AvionDealershipScreen extends StatelessWidget {
  Future<List<Avion>> loadAirplanes() async {
    String jsonString = await rootBundle.loadString('lib/files/vehicles.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> airplanesJson = jsonResponse['airplanes'];
    return airplanesJson.map((v) => Avion.fromJson(v)).toList();
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
              return Center(child: Text("Error loading vehicles"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Avion avion = snapshot.data![index];
                return ListTile(
                  title: Text(avion.name),
                  subtitle: Text('Price: \$${avion.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicle: avion)),
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
