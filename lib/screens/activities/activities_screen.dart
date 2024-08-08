import 'package:bit_life_like/screens/activities/activity/adoption_activites_screen.dart';
import 'package:bit_life_like/screens/activities/activity/blackmarket/blackmarket_activites_screen.dart';
import 'package:bit_life_like/screens/activities/activity/sport/sport_activites_screen.dart';
import 'package:flutter/material.dart';

import 'activity/criminal/criminal_activites_screen.dart';
import 'activity/legal/emigration_screen.dart';
import 'activity/health_check_screen.dart';
import 'activity/legal/inheritance_screen.dart';
import 'activity/legal/legal_action_screen.dart';
import 'activity/love_dating_screen.dart';
import 'activity/permits_screen.dart';
import 'activity/time_machine_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: ListView(
        children: <Widget>[
          _buildMenuItem(context, 'Sport Activities', SportActivitiesScreen()),
          _buildMenuItem(context, 'Criminal Activities', CriminalActivitiesScreen()),
          _buildMenuItem(context, 'Adoption', AdoptionActivitesScreen()),
          _buildMenuItem(context, 'Black Market', BlackmarketActivitesScreen()),
          _buildMenuItem(context, 'Health Check', HealthCheckScreen()),
          _buildMenuItem(context, 'Time Machine', TimeMachineScreen()),
          _buildMenuItem(context, 'Inheritance Management', InheritanceScreen()),
          _buildMenuItem(context, 'Emigration', EmigrationScreen()),
          _buildMenuItem(context, 'Legal Actions', LegalActionsScreen()),
          _buildMenuItem(context, 'Permits', PermitsScreen()),
          _buildMenuItem(context, 'Love and Dating', LoveDatingScreen()),
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
