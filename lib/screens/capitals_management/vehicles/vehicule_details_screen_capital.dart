import 'package:flutter/material.dart';

class VehiculeDetailsScreenCapital extends StatelessWidget {
  final dynamic vehicle; // Le véhicule peut être un Moto, Voiture, Bateau ou Avion

  VehiculeDetailsScreenCapital({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${vehicle.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Type: ${vehicle.runtimeType}", style: TextStyle(fontSize: 16)),
            Text("Age: ${vehicle.age} years", style: TextStyle(fontSize: 16)),
            Text("Value: \$${vehicle.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            Text("Rarity: ${vehicle.rarity}", style: TextStyle(fontSize: 16)),
            Text("Brand: ${vehicle.brand ?? 'N/A'}", style: TextStyle(fontSize: 16)),
            Text("Fuel Consumption: ${vehicle.fuelConsumption} liters/100km", style: TextStyle(fontSize: 16)),
            Text("Monthly Maintenance Cost: \$${vehicle.getMonthlyMaintenanceCost().toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
