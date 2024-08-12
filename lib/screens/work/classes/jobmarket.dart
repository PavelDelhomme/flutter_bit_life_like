import 'package:bit_life_like/services/work/jobmarket_service.dart';

import '../../../Classes/person.dart';
import 'job.dart';

class JobMarket {
  List<MarketJob> availableJobs;

  JobMarket({required this.availableJobs});

  void applyForJob(Person applicant, MarketJob job) {
    if (applicant.jobs.any((j) => j.title == job.jobTitle && j.companyName == job.employerName)) {
      print("You have already have this job.");
      return;
    }
    if (applicant.jobs.length >= 2 && job.jobType == "full-time") {
      print("Cannot apply for more than on full-time job.");
      return;
    }
    Job newJob = Job(
      title: job.jobTitle,
      country: applicant.country,
      salary: job.monthlySalary,
      hoursPerWeek: 40,
      companyName: job.employerName,
      isFullTime: job.jobType == "full-time",
    );
    applicant.jobs.add(newJob);
    print("${applicant.name} has started working as a ${job.jobTitle} at ${job.employerName}.");
  }

  void displayJobs() {
    for (var job in availableJobs) {
      print("Job: ${job.jobTitle}, Company: ${job.employerName}, Salary: \$${job.monthlySalary}");
    }
  }
}