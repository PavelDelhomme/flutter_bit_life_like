import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/activities/activity/blackmarket/blackmarket_activites_screen.dart';
import 'package:bit_life_like/screens/activities/activity/legal/emigration_screen.dart';
import 'package:bit_life_like/screens/activities/activity/legal/inheritance_screen.dart';
import 'package:bit_life_like/screens/activities/activity/legal/legal_action_screen.dart';
import 'package:bit_life_like/screens/activities/activity/other_activities/adoption_activites_screen.dart';
import 'package:bit_life_like/screens/activities/activity/other_activities/health_check_screen.dart';
import 'package:bit_life_like/screens/activities/activity/other_activities/love_dating_screen.dart';
import 'package:bit_life_like/screens/activities/activity/other_activities/permits_screen.dart';
import 'package:bit_life_like/screens/activities/activity/other_activities/time_machine_screen.dart';
import 'package:flutter/material.dart';

import 'activity/criminal/criminal_activites_screen.dart';
import 'activity/sport/sport_activites_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  final Person person;

  ActivitiesScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: ListView(
        children: <Widget>[
          _buildMenuItem(context, 'Sport Activities', SportActivitiesScreen(person: person)),
          _buildMenuItem(context, 'Criminal Activities', CriminalActivitiesScreen(person: person)),
          _buildMenuItem(context, 'Adoption', AdoptionActivitesScreen(person: person)),
          _buildMenuItem(context, 'Black Market', BlackmarketActivitesScreen(person: person)),
          _buildMenuItem(context, 'Health Check', HealthCheckScreen(person: person)),
          _buildMenuItem(context, 'Time Machine', TimeMachineScreen(person: person)),
          _buildMenuItem(context, 'Inheritance Management', InheritanceScreen(person: person)),
          _buildMenuItem(context, 'Emigration', EmigrationScreen(person: person)),
          _buildMenuItem(context, 'Legal Actions', LegalActionsScreen(person: person)),
          _buildMenuItem(context, 'Permits', PermitsScreen(person: person)),
          _buildMenuItem(context, 'Love and Dating', LoveDatingScreen(person: person)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget destinationScreen) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destinationScreen));
      },
    );
  }
}
