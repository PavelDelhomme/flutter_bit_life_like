import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bitlife_like/core/models/skill.dart';
import 'package:bitlife_like/core/models/skill_tree.dart';

class SkillTreeManager {
  static final SkillTreeManager _instance = SkillTreeManager._internal();
  factory SkillTreeManager() => _instance;
  SkillTreeManager._internal();

  late SkillTree currentSkillTree;

  Future<void> loadSkillTree() async {
    final data = await rootBundle.loadString('assets/data/character/skills.json');
    final decoded = json.decode(data) as Map<String, dynamic>;

    final Map<SkillCategory, List<SkillNode>> tree = {};

    for (var entry in decoded.entries) {
      final category = SkillCategory.values.firstWhere(
              (e) => e.toString().split('.').last == entry.key);

      final List<SkillNode> nodes = (entry.value as List).map((jsonNode) {
        final id = jsonNode['id'];
        final name = jsonNode['name'];

        final rawPrereqs = Map<String, dynamic>.from(jsonNode['prerequisites'] ?? {});
        final prereqs = rawPrereqs.map((key, value) => MapEntry(key, (value as num).toDouble()));

        return SkillNode(
          id,
          Skill(id: id, name: name, category: category),
          prereqs,
        );
      }).toList();

      tree[category] = nodes;
    }

    currentSkillTree = SkillTree(tree);
  }
}