import 'package:flutter/material.dart';

import '../../../../../../Classes/objects/vehicle.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Vehicle vehicle;

  VehicleDetailsScreen({required this.vehicle});

  void _purchaseVehicle(BuildContext context) {
    // Afficher un dialogue de confirmation d'achat
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmer l'achat"),
          content: Text("Êtes-vous sûr d'acheter ${vehicle.name} for \$${vehicle.value.toStringAsFixed(2)}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                // Processus d'achat ici
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Purchase"),
            )
          ],
        );
      },
    );
  }

  void _negotiatePrice(BuildContext context) {
    // Ouvrir une boîte de dialogue pour la négotiation
    final _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Négocier le prix"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Indiquer votre offre"),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Envoyer l'offre ici
                Navigator.of(context).pop();
              },
              child: Text("Placer l'offre"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${vehicle.name}", style: TextStyle(fontSize: 18)),
            Text("Type: ${vehicle.type}", style: TextStyle(fontSize: 18)),
            Text("Age: ${vehicle.age} years", style: TextStyle(fontSize: 18)),
            Text("Value: \$${vehicle.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
            Text("Rarity: ${vehicle.rarity}", style: TextStyle(fontSize: 18)),
            Text("Brand: ${vehicle.brand ?? 'N/A'}", style: TextStyle(fontSize: 18)),
            Text("Fuel Consumption: ${vehicle.fuelConsumption} L/100km", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _purchaseVehicle(context),
              child: Text('Purchase'),
            ),
            ElevatedButton(
              onPressed: () => _negotiatePrice(context),
              child: Text('Negotiate Price'),
            ),
          ],
        ),
      ),
    );
  }
}