import 'dart:math';

import '../../../Classes/person.dart';
import '../../../services/bank/bank_account.dart';

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
  List<Person> colleagues = [];


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

  void addColleague(Person colleague) {
    colleagues.add(colleague);
  }

  void generateColleagues(String country, int numberOfColleagues) {
    final random = Random();

    colleagues = List.generate(numberOfColleagues, (index) {
      return Person(
        name: 'Colleague ${index + 1}',
        gender: random.nextBool() ? 'Male' : 'Female',
        country: country,
        age: random.nextInt(30) + 20,
        prisonTerm: 0,
        isImprisoned: false,
        intelligence: random.nextDouble() * 50 + 50,
        happiness: random.nextDouble() * 50 + 50,
        karma: random.nextDouble() * 50 + 50,
        appearance: random.nextDouble() * 50 + 50,
        health: random.nextDouble() * 50 + 50,
        bankAccounts: [
          BankAccount(
            accountNumber: 'C${index + 1}ACC',
            bankName: 'Bank of Work',
            balance: random.nextDouble() * 5000 + 500,
            annualIncome: random.nextDouble() * 20000 + 10000,
            accountType: 'Checking',
          )
        ],
      );
    });
  }


}
