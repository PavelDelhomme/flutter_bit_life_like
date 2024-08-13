import 'package:flutter/material.dart';

import '../../../Classes/person.dart';
import 'my_jewelry_details_screen.dart';
import '../../../Classes/objects/jewelry.dart';

class MyJewelrysScreen extends StatelessWidget {
  final Person person;

  MyJewelrysScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    List<Jewelry> jewelries = person.collectibles.whereType<Jewelry>().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Jewelry"),
      ),
      body: ListView.builder(
        itemCount: jewelries.length,
        itemBuilder: (context, index) {
          var jewelry = jewelries[index];
          return ListTile(
            title: Text(jewelry.name),
            subtitle: Text("\$${jewelry.value.toStringAsFixed(2)} - ${jewelry.rarity}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JewelryDetailsScreen(jewelry: jewelry),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
