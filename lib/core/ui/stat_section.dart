import 'package:bitlife_like/core/shared/stat_data.dart';
import 'package:flutter/material.dart';

class StatSection extends StatelessWidget {
  final String title;
  final List<StatData> stats;

  const StatSection({super.key, required this.title, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats.map((stat) => Column(
                children: [
                  Icon(stat.icon, color: stat.color),
                  const SizedBox(height: 4),
                  Text(stat.label),
                  Text('${stat.value.toStringAsFixed(0)}%'),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}