import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../../../Classes/objects/vehicle.dart';


class CarDealershipScreen extends StatelessWidget {
  final List<Vehicle> vehicles;

  CarDealershipScreen(this.vehicles);

  Future<List<Voiture>> loadVehicles() async {
    String jsonString = await rootBundle.loadString('lib/files/vehicles.json');
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((v) => Voiture.fromJson(v)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Dealerships'),
      ),
      body: FutureBuilder<List<Voiture>>(
        future: loadVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading vehicles"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Voiture car = snapshot.data![index];
                return ListTile(
                  title: Text(car.name),
                  subtitle: Text('Price: \$${car.value.toStringAsFixed(2)}'),
                  onTap: () {
                    // Actions on tap, like showing details or initiating a purchase
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
