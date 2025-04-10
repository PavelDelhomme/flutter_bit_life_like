import 'package:flutter/material.dart';

import '../models/person/skill.dart';

class SkillTreeWidget extends StatelessWidget {
  final SkillTree tree;

  const SkillTreeWidget({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.1,
      maxScale: 2.0,
      child: CustomPaint(
        painter: SkillTreePainter(tree: tree),
        size: Size.infinite,
      ),
    );
  }
}

class SkillTreePainter extends CustomPainter {
  final SkillTree tree;
  final Map<SkillNode, Offset> nodePositions = {};

  SkillTreePainter({required this.tree});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    // Logique de dessin complexe pour positionner les nœuds
    _calculatePositions(size);

    // Dessiner les connexions
    tree.tree.forEach((category, nodes) {
      for (final node in nodes) {
        for (final prereq in node.prerequisites.keys) {
          final start = nodePositions[node];
          final end = nodePositions[_findNodeById(prereq)];
          if (start != null && end != null) {
            canvas.drawLine(start, end, Paint()..color = Colors.grey);
          }
        }
      }
    });

    // Dessiner les nœuds
    nodePositions.forEach((node, position) {
      canvas.drawCircle(position, 20, Paint()..color = Colors.blue);
    });
  }

  SkillNode? _findNodeById(String id) {
    try {
      return tree.tree.values
          .expand((nodes) => nodes)
          .firstWhere((node) => node.id == id);
    } catch (_) {
      return null;
    }
  }


  void _calculatePositions(Size size) {
    // Logique de positionnement automatique
  }
}
