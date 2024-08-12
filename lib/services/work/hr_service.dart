  import 'dart:math';

  import '../../screens/work/classes/business.dart';

  class HrService {
    final Random _random = Random();

    void conductInterview(Employee candidate, Function(bool) onResult) {
      bool interviewPassed = _random.nextDouble() > 0.3; // 70% chance of passing
      if (interviewPassed) {
        print("Congratulations, ${candidate.name}! You passed the interview.");
      } else {
        print("Sorry, ${candidate.name}. You did not pass the interview.");
      }
      onResult(interviewPassed);
    }

    void promoteEmployee(String employeeName, Business business) {
      try {
        Employee employee = business.employees.firstWhere((e) => e.name == employeeName);
        employee.salary *= 1.1;
        print("$employeeName has been promoted with a new salary of ${employee.salary}!");
      } catch (e) {
        print("Employee $employeeName not found.");
      }
    }

    double calculateEmployeeExpenses(List<Employee> employees) {
      return employees.fold(0, (sum, employee) => sum + employee.salary);
    }
  }