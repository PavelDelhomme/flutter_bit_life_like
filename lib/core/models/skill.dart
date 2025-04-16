import 'package:bitlife_like/core/models/skill_tree.dart';

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
    'negociation': SkillCategory.social,
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