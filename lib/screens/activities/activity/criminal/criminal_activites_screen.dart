import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';

class CriminalActivitiesScreen extends StatelessWidget {
  final Person person;

  CriminalActivitiesScreen({required this.person});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criminal Activities'),
      ),
      body: Center(
        child: Text('List of criminal activities here'),
      ),
    );
  }
}
