class Etude {
  String fieldOfStudy;
  String institution;
  int startYear;
  int endYear;
  bool isCompleted;

  Etude({
    required this.fieldOfStudy,
    required this.institution,
    required this.startYear,
    required this.endYear,
    this.isCompleted = false,
  });

  void completeStudy() {
    isCompleted = true;
  }

  @override
  String toString() {
    return '$fieldOfStudy at $institution from $startYear to $endYear, Completed: $isCompleted';
  }
}
