import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activité'),
      ),
      body: const Center(
        child: Text('Écran des activités a faire'),
      ),
    );
  }
}
