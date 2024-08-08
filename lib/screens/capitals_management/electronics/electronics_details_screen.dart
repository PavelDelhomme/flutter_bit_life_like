import 'package:flutter/material.dart';

import '../../../Classes/objects/electronic.dart';

class ElectronicsDetailsScreen extends StatelessWidget {
  final Electronic electronic;

  ElectronicsDetailsScreen({required this.electronic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${electronic.brand} ${electronic.model}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Type: ${electronic.type}", style: TextStyle(fontSize: 18)),
            Text("Brand: ${electronic.brand}", style: TextStyle(fontSize: 16)),
            Text("Model: ${electronic.model}", style: TextStyle(fontSize: 16)),
            Text("Price: \$${electronic.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            if (electronic.supportsApplications) ...[
              Text("Supports Applications", style: TextStyle(fontSize: 16, color: Colors.green)),
            ],
          ],
        ),
      ),
    );
  }
}
