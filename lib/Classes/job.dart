class Job {
  String title;
  String country;
  double salary;
  int hoursPerWeek;
  int workedSemesters = 0;

  Job({required this.title, required this.country, required this.salary, required this.hoursPerWeek});

  void workSemester() {
    workedSemesters +=1;
  }
}