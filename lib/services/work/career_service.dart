import '../../screens/work/object/job.dart';
import '../../Classes/person.dart';

class CareerService {
  void applyForJob(Person person, Job job) {
    person.jobs.add(job);
    // Logique pour gérer l'application de l'emploi
    print('${person.name} applied for a job as a ${job.title}.');
  }

  void retireFromJob(Person person, Job job) {
    person.retire(job);
    // Logique pour gérer la retraite
    print('${person.name} retired from the job as a ${job.title}.');
  }
}
