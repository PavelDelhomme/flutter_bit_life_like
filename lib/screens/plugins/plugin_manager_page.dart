import 'package:bitlife_like/services/activity_system.dart';
import 'package:bitlife_like/services/bank/financial_service.dart';
import 'package:bitlife_like/services/time_age_event/age_service.dart';
import 'package:bitlife_like/services/time_age_event/events/events_decision/event_service.dart';
import 'package:bitlife_like/services/time_age_event/time_service.dart';
import 'package:bitlife_like/utils/random_generator.dart';
import 'package:flutter/material.dart';

import 'package:bitlife_like/plugins/plugin_manager.dart';
import 'package:bitlife_like/plugins/plugins/plugin_context.dart';

import '../../models/person/character.dart';
import '../../utils/context_builder.dart';

class PluginManagerPage extends StatefulWidget {
  final Character character;
  PluginManagerPage({required this.character});

  @override
  _PluginManagerPageState createState() => _PluginManagerPageState();
}

class _PluginManagerPageState extends State<PluginManagerPage> {
  final PluginManager pluginManager = PluginManager(); // Assure-toi que c'est le même instance utilisée dans toute l'application

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionnaire de Plugins'),
      ),
      body: ListView(
        children: pluginManager.allPlugins.map((plugin) {
          final isActive = pluginManager.activePlugins.contains(plugin);
          return SwitchListTile(
            title: Text(plugin.name),
            subtitle: Text(plugin.description),
            value: isActive,
            onChanged: (value) {
              setState(() {
                final context = buildGamePluginContext(widget.character);
                if (value) {
                  pluginManager.enablePlugin(plugin.id, context);
                } else {
                  pluginManager.disablePlugin(plugin.id, context);
                }
              });
            }
          );
        }).toList(),
      ),
    );
  }
}
