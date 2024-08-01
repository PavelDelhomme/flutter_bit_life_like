import 'package:flutter/material.dart';

class RelationshipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relationships'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Family'),
            onTap: () {
              // Action pour la famille
            },
          ),
          ListTile(
            title: Text('Friends'),
            onTap: () {
              // Action pour les amis
            },
          ),
          ListTile(
            title: Text('Pets'),
            onTap: () {
              // Action pour les animaux de compagnie
            },
          ),
        ],
      ),
    );
  }
}
