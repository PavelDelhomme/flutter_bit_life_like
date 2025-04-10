import 'dart:math';

import 'package:bitlife_like/models/person/character.dart';

enum SkillCategory {
  technical,
  social,
  physical,
  intellectual,
  creative,
  criminal
}

class SkillTree {
  final Map<SkillCategory, List<SkillNode>> tree;

  SkillTree(this.tree);

  List<Skill> getAvailableSkills(Character character) {
    return tree.values.expand((nodes) => nodes.where((node) {
      return node.prerequisites.entries.every((entry) { // Utiliser entries
        final skillId = entry.key;
        final requiredLevel = entry.value;
        return (character.skills[skillId]?.currentLevel ?? 0) >= requiredLevel;
      });
    }).map((node) => node.skill)).toList();
  }
}


class SkillNode {
  final String id;
  final Skill skill;
  final Map<String, double> prerequisites; // {skillId: niveau requis}

  SkillNode(this.id, this.skill, this.prerequisites);
}


class SkillMastery {
  final String skillId;
  double experience;
  DateTime lastUsed;

  SkillMastery(this.skillId, this.experience, this.lastUsed);

  double get currentLevel => sqrt(experience / 1000).clamp(0.0, 10.0);

  void addExperience(double amount, SkillCategory category) {
    experience += amount * getCategoryMultiplier(category);
    lastUsed = DateTime.now();
  }

  double getCategoryMultiplier(SkillCategory category) {
    switch(category) {
      case SkillCategory.technical: return 1.2;
      case SkillCategory.social: return 1.0;
      case SkillCategory.physical: return 0.8;
      case SkillCategory.intellectual: return 1.5;
      case SkillCategory.creative: return 1.1;
      case SkillCategory.criminal: return 0.9;
    }
  }
}

class Skill {
  final String id;
  final String name;
  final SkillCategory category;
  double experience; // Points d'expérience accumulés
  double maxLevel; // Niveau maximum atteignable
  DateTime lastPracticed;
  
  Skill({
    required this.id,
    required this.name,
    required this.category,
    this.experience = 0,
    this.maxLevel = 100,
    required this.lastPracticed,
  });

  double get currentLevel => _calculateLevel(experience);

  double _calculateLevel(double exp) {
    return (exp / 1000).clamp(0, maxLevel);
  }

  void addExperience(double amount) {
    experience += amount * _getCategoryMultiplier();
    lastPracticed = DateTime.now();
  }

  double _getCategoryMultiplier() {
    switch (category) {
      case SkillCategory.technical: return 1.2;
      case SkillCategory.social: return 1.0;
      case SkillCategory.physical: return 0.8;
      case SkillCategory.intellectual: return 1.5;
      case SkillCategory.creative: return 1.1;
      case SkillCategory.criminal: return 0.9;
    }
  }

  void improve(double amount) {
    level = (level + amount).clamp(0.0, 1.0);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toString(),
      'experience': experience,
      'maxLevel': maxLevel,
      'lastPracticed': lastPracticed.toIso8601String(),
    };
  }
  
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      category: SkillCategory.values.firstWhere((c) => c.toString() == json['category']),
      experience: json['experience'],
      maxLevel: json['maxLevel'],
      lastPracticed: DateTime.parse(json['lastPracticed']),
    );
  }
}