import 'package:flutter/material.dart';

class RelationshipsScreen extends StatelessWidget {
  const RelationshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relations'),
      ),
      body: const Center(
        child: Text('Écran des relations'),
      ),
    );
  }
}
