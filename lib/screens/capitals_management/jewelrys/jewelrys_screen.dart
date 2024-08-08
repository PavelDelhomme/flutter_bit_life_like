import 'package:flutter/material.dart';

import '../../../Classes/person.dart';
import 'jewelry_details_screen.dart';


class JewelrysScreen extends StatelessWidget {
  final Person person;

  JewelrysScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jewelry"),
      ),
      body: ListView.builder(
        itemCount: person.jewelries.length,
        itemBuilder: (context, index) {
          var jewelry = person.jewelries[index];
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