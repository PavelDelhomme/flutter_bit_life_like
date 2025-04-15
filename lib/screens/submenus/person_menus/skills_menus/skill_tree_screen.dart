import 'package:flutter/material.dart';
import 'package:bitlife_like/services/skill_tree_manager.dart';
import 'package:bitlife_like/widgets/skill_tree_widget.dart';

class SkillTreeScreen extends StatelessWidget {
  const SkillTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tree = SkillTreeManager().currentSkillTree;

    return Scaffold(
      appBar: AppBar(title: const Text('Skill Tree')),
      body: SkillTreeWidget(tree: tree),
    );
  }
}
