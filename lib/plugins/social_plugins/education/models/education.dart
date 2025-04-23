class Course {
  final String id;
  final String name;
  final Map<String, double> requiredSkills;
  final Map<String, double> skillRewards;
  final Duration duration;
  final double cost;

  Course({
    required this.id,
    required this.name,
    required this.requiredSkills,
    required this.skillRewards,
    required this.duration,
    required this.cost,
  });
}
