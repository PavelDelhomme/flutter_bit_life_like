// jobmarket.dart
import 'package:bit_life_like/screens/work/classes/job.dart';

import '../../../Classes/person.dart';

class JobMarket {
  List<Job> availableJobs;

  JobMarket({required this.availableJobs});

  void applyForJob(Person applicant, Job job) {
    if (applicant.jobs.contains(job)) {
      print("You already have this job.");
      return;
    }
    if (applicant.jobs.length >= 2 && job.isFullTime) {
      print("Cannot apply for more than one full-time job.");
      return;
    }
    applicant.jobs.add(job);
    print("${applicant.name} has started working as a ${job.title} at ${job.companyName}.");
  }

  void displayJobs() {
    for (var job in availableJobs) {
      print("Job: ${job.title}, Company: ${job.companyName}, Salary: \$${job.salary}");
    }
  }
}
