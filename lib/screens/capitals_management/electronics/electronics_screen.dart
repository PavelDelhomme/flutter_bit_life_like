import 'package:flutter/material.dart';

import '../../../Classes/objects/electronic.dart';
import 'electronics_details_screen.dart';

class MyElectronicsScreen extends StatelessWidget {
  final List<Electronic> electronics;

  MyElectronicsScreen({required this.electronics});

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
            subtitle: Text('\$${electronic.value}'),
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
