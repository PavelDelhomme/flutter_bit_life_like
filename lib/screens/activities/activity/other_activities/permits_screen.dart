import 'package:bit_life_like/screens/activities/activity/other_activities/permit/permit_exam_screen.dart';
import 'package:flutter/material.dart';

import '../../../../Classes/person.dart';

class PermitsScreen extends StatelessWidget {
  final Person person;

  PermitsScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permits'),
      ),
      body: ListView(
        children: <Widget>[
          _buildPermitItem(context, "Car Permit", 'car'),
          _buildPermitItem(context, "Motorcycle Permit", 'motorcycle'),
          _buildPermitItem(context, "Boat Permit", 'boat'),
          _buildPermitItem(context, "Plane Permit", 'plane'),
        ],
      )
    );
  }

  Widget _buildPermitItem(BuildContext context, String title, String permitType) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PermitExamScreen(permitType: permitType, person: person)
          ),
        );
      },
    );
  }
}
