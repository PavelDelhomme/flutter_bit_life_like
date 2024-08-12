import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';

class AdoptionActivitesScreen extends StatelessWidget {
  final Person person;

  AdoptionActivitesScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sport Activities'),
      ),
      body: Center(
        child: Text('List of sport activities here'),
      ),
    );
  }
}
