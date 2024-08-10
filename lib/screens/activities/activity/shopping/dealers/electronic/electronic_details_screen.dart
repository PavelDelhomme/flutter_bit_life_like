import 'package:flutter/material.dart';
import '../../../../../../Classes/objects/electronic.dart';

class ElectronicsDetailsScreen extends StatelessWidget {
  final Electronic electronic;

  ElectronicsDetailsScreen({required this.electronic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${electronic.brand} ${electronic.model}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Type: ${electronic.type}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Brand: ${electronic.brand}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Model: ${electronic.model}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Price: \$${electronic.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, color: Colors.green)),
            SizedBox(height: 20),
            if (electronic.supportsApplications)
              Text("Supports Applications: Yes", style: TextStyle(fontSize: 16, color: Colors.green)),
            if (!electronic.supportsApplications)
              Text("Supports Applications: No", style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _purchaseElectronic(context),
              child: Text("Purchase"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _purchaseElectronic(BuildContext context) {
    // Implement purchase logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Purchase Confirmation"),
          content: Text("Are you sure you want to purchase the ${electronic.model}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Additional actions on confirmation
              },
              child: const Text("Confirm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
