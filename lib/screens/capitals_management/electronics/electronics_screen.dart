import 'package:flutter/material.dart';

import '../../../Classes/objects/electronic.dart';
import 'electronics_details_screen.dart';

class ElectronicsScreen extends StatelessWidget {
  final List<Electronic> electronics;

  ElectronicsScreen({required this.electronics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Electronics")),
      body: ListView.builder(
        itemCount: electronics.length,
        itemBuilder: (context, index) {
          Electronic electronic = electronics[index];
          return ListTile(
            title: Text('${electronic.brand} ${electronic.model}'),
            subtitle: Text('\$${electronic.price}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElectronicsDetailsScreen(electronic: electronic)),
              );
            },
          );
        },
      ),
    );
  }
}
