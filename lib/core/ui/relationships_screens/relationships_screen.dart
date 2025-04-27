import 'package:flutter/material.dart';
import '../../models/character.dart';

class RelationshipsScreen extends StatelessWidget {
  final Character character;

  const RelationshipsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relations")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: character.relationships.map((rel) => ListTile(
          title: Text(rel.strength as String),
          subtitle: Text("Relation : ${rel.type.name}"),
        )).toList(),
      ),
    );
  }
}
