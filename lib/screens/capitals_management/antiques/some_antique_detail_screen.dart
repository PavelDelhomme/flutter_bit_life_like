import 'package:flutter/material.dart';
import '../../../../../../Classes/objects/antique.dart';

class SomeAntiqueDetailScreen extends StatelessWidget {
  final Antique antique;

  SomeAntiqueDetailScreen({required this.antique});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${antique.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${antique.name}', style: TextStyle(fontSize: 18)),
            Text('Value: \$${antique.value.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            Text('Age: ${antique.age} years', style: TextStyle(fontSize: 18)),
            Text('Artist: ${antique.artist}', style: TextStyle(fontSize: 18)),
            Text('Rarity: ${antique.rarity}', style: TextStyle(fontSize: 18)),
            Text('Epoch: ${antique.epoch}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
