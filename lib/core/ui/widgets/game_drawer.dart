

import 'package:bitlife_like/core/models/character.dart';
import 'package:flutter/material.dart';

import '../../../plugin_manager.dart';
import '../plugin_screens/plugin_manager_screen.dart';

class GameDrawer extends StatelessWidget {
  final Character character;

  const GameDrawer({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.red),
            child: Text(
              character.fullName,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text("Sauvegarder"),
            onTap: () async {
              Navigator.pop(context);
              await character.save();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sauvegarde effectuée")),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Mes vies"),
            onTap: () => Navigator.pushReplacementNamed(context, '/start'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Nouvelle vie"),
            onTap: () => Navigator.pushReplacementNamed(context, '/characterCreation'),
          ),
          ListTile(
            leading: const Icon(Icons.extension),
            title: const Text("Plugins"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PluginManagerPage()),
              );
            },
          ),
          const Divider(),
          ...PluginManager.instance.getMainMenuItems(context).map((entry) => ListTile(
            leading: Icon(entry.icon),
            title: Text(entry.title),
            onTap: entry.onTap,
          )),
        ],
      ),
    );
  }
}