import '../../screens/work/classes/job.dart';
import '../../Classes/person.dart';

class CareerService {
  void applyForJob(Person person, String jobTitle) {
    Job job = Job(
        title: jobTitle,
        salary: 50000,  // Adjust salary based on jobTitle or other parameters
        country: person.country,
        hoursPerWeek: 40,
        companyName: "Generic Company",  // Default company name, adjust as needed
        isFullTime: true  // Assume full-time by default, adjust as necessary
    );
    // Existing logic to handle job application
    person.jobs.add(job);
    print("${person.name} has been applied for ${job.title} at ${job.companyName}.");
  }
}
