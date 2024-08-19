import 'package:bit_life_like/Classes/event.dart';
import '../../../Classes/life_history_event.dart';
import '../../../Classes/person.dart';
import '../../life_state.dart';

class DecisionService {
  void makeDecision(Person person, Event event, String choice) {
    if (event.choices != null && event.choices!.containsKey(choice)) {
      Map<String, dynamic> effects = event.choices![choice]!;

      if (effects.containsKey('relationshipImpact')) {
        person.updateRelationship(effects['targetPersonId'], effects['relationshipImpact']);
      }

      if (effects.containsKey('financialImpact')) {
        person.updateFinancialStatus(effects['financialImpact']);
      }

      person.addLifeHistoryEvent(LifeHistoryEvent(
        description: "Event: ${event.name} - Choice: $choice",
        timestamp: DateTime.now(),
      ));
    }
  }
}
