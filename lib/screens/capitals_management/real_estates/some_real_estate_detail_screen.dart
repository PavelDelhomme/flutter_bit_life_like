import 'package:flutter/material.dart';

class SomeRealEstateDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> estate;

  SomeRealEstateDetailsScreen({required this.estate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of ${estate['nom']}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${estate['nom']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Type: ${estate['type']}", style: TextStyle(fontSize: 16)),
            Text("Age: ${estate['age']} years", style: TextStyle(fontSize: 16)),
            Text("Value: \$${estate['valeur'].toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            Text("Condition: ${estate['condition']}", style: TextStyle(fontSize: 16)),
            Text("Monthly Maintenance: \$${estate['monthly_maintenance_cost'].toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
