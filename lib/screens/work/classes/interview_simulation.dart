import 'dart:math';

class Candidate {
  String name;
  double expectedSalary;

  Candidate({required this.name, required this.expectedSalary});
}

class Interview {
  static final Random _random = Random();

  static final List<Candidate> _candidates = [
    Candidate(name: 'Alice', expectedSalary: 50000),
    Candidate(name: 'Bob', expectedSalary: 45000),
    Candidate(name: 'Charlie', expectedSalary: 60000),
    Candidate(name: 'Diana', expectedSalary: 55000),
  ];

  static List<Candidate> getAvailableCandidates() {
    return _candidates;
  }

  static bool simulate(Candidate candidate) {
    print("Interviewing ${candidate.name} for a salary of \$${candidate.expectedSalary}");
    // Simulate an interview where the candidate gets 70% chance to pass
    return _random.nextDouble() > 0.3;
  }
}
