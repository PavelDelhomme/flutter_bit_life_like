import 'package:bit_life_like/screens/capitals_management/vehicles/vehicule_details_screen_capital.dart';
import 'package:flutter/material.dart';

class VehicleListScreen extends StatelessWidget {
  final String title;
  final List<dynamic> vehicles;

  VehicleListScreen({required this.title, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return ListTile(
            title: Text(vehicle.name),
            subtitle: Text("Value: \$${vehicle.value.toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehiculeDetailsScreenCapital(vehicle: vehicle),
                ),
              );
            },
          );
        },
      ),
    );
  }
}