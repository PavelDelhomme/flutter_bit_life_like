  import 'dart:math';

  import '../../screens/work/classes/business.dart';

  class HrService {
    final Random _random = Random();

    void conducInterview(String candidateName) {
      bool interviewPassed = _random.nextDouble() > 0.3; // 70% chance of passing
      if (interviewPassed) {
        print("Congratulations, $candidateName! You passed the interview.");
      } else {
        print("Sorry, $candidateName. You did not pass the interview.");
      }
    }

    void promoteEmployee(String employeeName) {
      print("$employeeName has been promoted !");
    }

    double calculateEmployeeExpenses(List<Employee> employees) {
      return employees.fold(0, (sum, employee) => sum + employee.salary);
    }
  }