import '../../Classes/activity.dart';
import '../../Classes/life_history_event.dart';
import '../../Classes/person.dart';

class ActivityService {
  void performActivity(Person person, Activity activity, {Person? targetPerson}) {
    person.updateFinancialStatus(-activity.cost);

    if (activity.relationImpact != 0 && targetPerson != null) {
      person.updateRelationship(targetPerson.id, activity.relationImpact);
    }

    if (activity.skillRequired.isNotEmpty) {
      person.updateSkill(activity.skillRequired, activity.skillImpact);
    }

    person.addLifeHistoryEvent(LifeHistoryEvent(
      description: "${person.name} performed ${activity.name}",
      timestamp: DateTime.now(),
    ));
  }
}
