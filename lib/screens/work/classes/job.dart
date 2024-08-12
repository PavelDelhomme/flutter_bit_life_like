class Job {
  String title;
  String country;
  double salary;  // Salary per hour
  int hoursPerWeek;
  int workedSemesters = 0;
  double stressLevel = 0;
  String companyName;
  bool isFullTime;
  String educationRequired = "Any";
  int yearsRequired = 0;


  Job({required this.title, required this.country, required this.salary, required this.hoursPerWeek, required this.companyName, required this.isFullTime});

  void workSemester() {
    workedSemesters += 1;
  }

  double calculateStress(double health) {
    double baseStress = hoursPerWeek > 40 ? (hoursPerWeek - 40) * 0.5 : 0;
    return baseStress + (100 - health) * 0.1;
  }

  double calculateOvertimePay(int overtimeHours) {
    if (overtimeHours > 0) {
      return overtimeHours * salary * 1.5; // 1.5x the hourly rate for overtime
    }
    return 0.0;
  }
}
