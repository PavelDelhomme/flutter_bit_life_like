import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';

class JewelryDetailsScreen extends StatelessWidget {
  final Jewelry jewelry;

  JewelryDetailsScreen({required this.jewelry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of ${jewelry.name}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${jewelry.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Value: ${jewelry.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            Text("Rarity: ${jewelry.rarity}", style: TextStyle(fontSize: 16)),
            Text("Brand: ${jewelry.brand}", style: TextStyle(fontSize: 16)),
            Text("Carat: ${jewelry.carat}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}