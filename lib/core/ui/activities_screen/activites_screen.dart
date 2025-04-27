import 'package:flutter/material.dart';

import '../../../plugin_manager.dart';
import '../../models/character.dart';
import '../../plugin/activity_provider.dart';

class ActivitiesScreen extends StatelessWidget {
  final Character character;

  const ActivitiesScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final activities = _getAvailableActivities();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final entry = activities[index];
          return Card(
            child: ListTile(
              leading: Icon(entry.icon, color: Colors.red),
              title: Text(entry.title),
              onTap: entry.onTap,
            ),
          );
        },
      ),
    );
  }

  List<ActivityEntry> _getAvailableActivities() {
    final activities = <ActivityEntry>[];

    for (final plugin in PluginManager.instance.plugins) {
      if (plugin is ActivityProvider) {
        activities.addAll((plugin as ActivityProvider).getActivities());
      }
    }

    return activities;
  }
}
