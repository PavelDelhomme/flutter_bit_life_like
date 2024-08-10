import 'dart:math';

class HRService {
  final Random _random = Random();

  void conductInterview(String candidateName) {
    bool interviewPassed = _random.nextDouble() > 0.3; // 70% chance of passing
    if (interviewPassed) {
      print("Congratulations, $candidateName! You passed the interview.");
    } else {
      print("Sorry, $candidateName. You did not pass the interview.");
    }
  }

  void promoteEmployee(String employeeName) {
    print("$employeeName has been promoted!");
  }
}
