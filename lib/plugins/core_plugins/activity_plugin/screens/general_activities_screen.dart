import 'package:flutter/material.dart';

class GeneralActivitiesScreen extends StatelessWidget {
  const GeneralActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ActivityOption> activities = [
      ActivityOption("Courir dans le parc", Icons.directions_run),
      ActivityOption("Jouer d'un instrument", Icons.music_note),
      ActivityOption("Faire du bénévolat", Icons.volunteer_activism),
      ActivityOption("Voyager", Icons.flight),
      ActivityOption("Apprendre la cuisine", Icons.restaurant),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activités Générales"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: Icon(activity.icon, color: Colors.red),
            title: Text(activity.title),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tu as fait : ${activity.title} !")),
              );
            },
          );
        },
      ),
    );
  }
}

class ActivityOption {
  final String title;
  final IconData icon;

  ActivityOption(this.title, this.icon);
}
