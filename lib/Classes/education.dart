class EducationLevel {
  String name;
  int minAge;
  int maxAge;
  double cost;
  bool requiresScholarship;
  List<String> specializations;

  EducationLevel({
    required this.name,
    required this.minAge,
    required this.maxAge,
    this.cost = 0,
    this.requiresScholarship = false,
    this.specializations = const [],
  });
}
