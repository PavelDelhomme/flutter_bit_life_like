import 'package:flutter/material.dart';

class ActivityEntry {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  ActivityEntry({required this.title, required this.icon, required this.onTap});
}

abstract class ActivityProvider {
  List<ActivityEntry> getActivities();
}
