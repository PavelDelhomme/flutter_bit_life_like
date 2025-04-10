import 'dart:math';

import 'package:bitlife_like/models/person/character.dart';
import 'package:hive/hive.dart';

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
@HiveType(typeId: 6)
class SkillMastery extends HiveObject {
  @HiveField(0)
  final String skillId;

  @HiveField(1)
  double experience;

  @HiveField(2)
  DateTime lastUsed;

  @HiveField(3)
  final SkillCategory category;

  SkillMastery({
    required this.skillId,
    this.experience = 0,
    required this.category,
    required this.lastUsed,
  });

  double get currentLevel => sqrt(experience / 1000).clamp(0.0, 10.0);

  void addExperience(double amount) {
    experience += amount * getCategoryMultiplier();
    lastUsed = DateTime.now();
  }

  double getCategoryMultiplier() {
    switch(category) {
      case SkillCategory.technical: return 1.2;
      case SkillCategory.social: return 1.0;
      case SkillCategory.physical: return 0.8;
      case SkillCategory.intellectual: return 1.5;
      case SkillCategory.creative: return 1.1;
      case SkillCategory.criminal: return 0.9;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'experience': experience,
      'lastUsed': lastUsed.toIso8601String(),
      'category': category.toString(),
    };
  }
}


class Skill {
  final String id;
  final String name;
  final SkillCategory category;

  Skill({
    required this.id,
    required this.name,
    required this.category,
  });

  static final Map<String, SkillCategory> _skillCategoryMap = {
    'programming': SkillCategory.technical,
    'negotiation': SkillCategory.social,
    'driving': SkillCategory.physical,
    'lecture': SkillCategory.intellectual,
    'jouer': SkillCategory.creative,
    'voler': SkillCategory.criminal,
    'art': SkillCategory.creative,
    'hacking': SkillCategory.criminal,
    'management': SkillCategory.social,
    'accounting': SkillCategory.intellectual,
    'marketing': SkillCategory.creative,
    'logistics': SkillCategory.technical,
    'negociation': SkillCategory.social;
  };

  static SkillCategory getCategoryFromId(String skillId) {
    return _skillCategoryMap[skillId] ?? SkillCategory.technical;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toString(),
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      category: SkillCategory.values.firstWhere(
          (e) => e.toString() == json['category'],
          orElse: () => SkillCategory.technical,
      ),
    );
  }
}

/*
class Skill {
  final String id;
  final String name;
  final SkillCategory category;
  double experience; // Points d'expérience accumulés
  double maxLevel; // Niveau maximum atteignable
  DateTime lastPracticed;


  static final Map<String, SkillCategory> _skillCategoryMap = {
    'programming': SkillCategory.technical,
    'negotiation': SkillCategory.social,
    'driving': SkillCategory.physical,
    'lecture': SkillCategory.intellectual,
    'jouer': SkillCategory.creative,
    'voler': SkillCategory.criminal
    // Ajouter tous les skillIds avec leurs catégories
  };

  static SkillCategory getCategoryFromId(String skillId) {
    return _skillCategoryMap[skillId] ?? SkillCategory.technical;
  }

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
 */