import 'job.dart';

class RetirementRules {
  String country;
  int retirementAge;
  int requiredSemesters;
  double pensionPercentage;

  RetirementRules({required this.country, required this.retirementAge, required this.requiredSemesters, required this.pensionPercentage});
}

class RetirementServicet {
  Map<String, RetirementRules> rules = {
    'France': RetirementRules(country: 'France', retirementAge: 62, requiredSemesters: 160, pensionPercentage: 0.75),
    'USA': RetirementRules(country: 'USA', retirementAge: 67, requiredSemesters: 140, pensionPercentage: 0.70),
    'U.K.': RetirementRules(country: 'U.K', retirementAge: 65, requiredSemesters: 130, pensionPercentage: 0.68),
  };

  bool isEligibleForRetirement(Person person, Job job) {
    if (rules.containsKey(job.country)) {
      RetirementRules countryRules = rules[job.country]!;
      return person.age >= countryRules.retirementAge && job.workedSemesters >= countryRules.requiredSemesters;
    }
    return false;
  }

  double calculatePension(Job job) {
    if(rules.containsKey(job.country)) {
      RetirementRules countryRules = rules[job.country]!;
      return job.salary * countryRules.pensionPercentage;
    }
    return 0.0;
  }
}