import 'package:flutter/material.dart';

class PluginMenuEntry {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  PluginMenuEntry({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}