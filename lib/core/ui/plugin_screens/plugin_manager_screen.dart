import 'package:flutter/material.dart';
import '../../../plugin_manager.dart';

class PluginManagerPage extends StatefulWidget {
  const PluginManagerPage({super.key});

  @override
  State<PluginManagerPage> createState() => _PluginManagerPageState();
}

class _PluginManagerPageState extends State<PluginManagerPage> {
  @override
  Widget build(BuildContext context) {
    final availablePlugins = PluginManager.instance.availablePlugins;
    final activePlugins = PluginManager.instance.plugins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Plugins'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: availablePlugins.length,
        itemBuilder: (context, index) {
          final plugin = availablePlugins[index];
          final isActive = activePlugins.any((p) => p.id == plugin.id);

          return SwitchListTile(
            title: Text(plugin.name),
            subtitle: Text(plugin.id),
            value: isActive,
            onChanged: (bool value) {
              setState(() {
                PluginManager.instance.setPluginActive(plugin, value);
              });
            },
          );
        },
      ),
    );
  }
}