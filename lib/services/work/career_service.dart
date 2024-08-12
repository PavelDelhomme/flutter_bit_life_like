import 'package:bit_life_like/services/work/jobmarket_service.dart';

import '../../screens/work/classes/job.dart';
import '../../Classes/person.dart';
import '../bank/bank_account.dart';

class CareerService {
  void applyForJob(Person person, MarketJob marketJob) {
    Job job = Job(
      title: marketJob.jobTitle,
      salary: marketJob.monthlySalary, // Adjust salary based on jobTitle or other parameters
      country: person.country,
      hoursPerWeek: 40,
      companyName: marketJob.employerName, // Default company name, adjust as needed
      isFullTime: marketJob.jobType == "full-time", // Assume full-time by default, adjust as necessary
    );
    // Existing logic to handle job application
    person.jobs.add(job);
    print("${person.name} has been applied for ${job.title} at ${job.companyName}.");
  }

  void resignFromJob(Person person, Job job) {
    if (person.jobs.contains(job)) {
      person.jobs.remove(job);
      person.jobHistory.add(job);
      print("${person.name} has resigned from ${job.title} at ${job.companyName}.");
      person.stressLevel -= 10; // Reduce stress on resignation
      provideUnemploymentBenefits(person);
    }
  }

  void provideUnemploymentBenefits(Person person) {
    // Add logic to provide unemployment benefits
    BankAccount? primaryAccount = person.bankAccounts.isNotEmpty ? person.bankAccounts.first : null;
    if (primaryAccount != null) {
      double benefitAmount = 500; // Example benefit amount
      primaryAccount.deposit(benefitAmount);
      print("Unemployment benefit of \$${benefitAmount} provided to ${person.name}.");
    }
  }

  void requestPromotion(Job job) {
    // Logic to requesting a promotion
    print("Requesting promotion for ${job.title} at ${job.companyName}");
  }
}
