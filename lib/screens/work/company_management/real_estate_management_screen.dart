import 'package:flutter/material.dart';

import '../../../Classes/objects/real_estate.dart';

class RealEstateManagementScreen extends StatelessWidget {
  final List<RealEstate> properties;

  RealEstateManagementScreen({required this.properties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Estate Management'),
      ),
      body: ListView(
        children: properties.map((property) {
          return ListTile(
            title: Text(property.name),
            subtitle: Text('Condition: ${property.condition.toStringAsFixed(2)}%'),
            onTap: () {
              // Manage property
            },
          );
        }).toList(),
      ),
    );
  }
}
