import 'package:flutter/material.dart';


class PluginMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  PluginMenuItem({required this.title, required this.icon, required this.onTap});
}
