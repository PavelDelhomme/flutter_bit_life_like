import 'package:flutter/material.dart';
import '../../../plugins/core_plugins/skills_extended/widgets/skill_tree_widget.dart';
import '../../models/skill_tree.dart';

class SkillTreeScreen extends StatelessWidget {
  final SkillTree skillTree;

  const SkillTreeScreen({super.key, required this.skillTree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Arbre de Compétences")),
      body: SkillTreeWidget(tree: skillTree),
    );
  }
}
