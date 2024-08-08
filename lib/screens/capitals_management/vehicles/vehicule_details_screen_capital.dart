import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';

class VehiculeDetailsScreenCapital extends StatelessWidget {
  final Vehicle vehicle;

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
            Text("Name : ${vehicle.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Type : ${vehicle.type}", style: TextStyle(fontSize: 16)),
            Text("Age : ${vehicle.age} years", style: TextStyle(fontSize: 16)),
            Text("Value : ${vehicle.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            Text("Rarity : ${vehicle.rarity}", style: TextStyle(fontSize: 16)),
            Text("Brand : ${vehicle.brand ?? 'N/A'}", style: TextStyle(fontSize: 16)),
            Text("Fuel Consumption: ${vehicle.fuelConsumption} liters/100km", style: TextStyle(fontSize: 16)),
            Text("Monthly Maintenance Cost: \$${vehicle.getMonthlyMaintenanceCost().toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}