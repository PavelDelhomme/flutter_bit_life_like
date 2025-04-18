import '../game_event.dart';

class EventManager {
  final List<GameEvent> _globalEvents = [];

  void triggerWorldEvents(int year) {
    if (year % 5 == 0) {
      _globalEvents.add(GameEvent.global('Une cris économique mondiale secoue les marchés'));
    }
    // propagation aux PNJ
  }

  List<GameEvent> getGlobalEvents() => _globalEvents;
}