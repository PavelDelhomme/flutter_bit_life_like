import 'package:bitlife_like/core/system/world/npc_manager.dart';

import '../game_event.dart';

class EventManager {
  final List<GameEvent> _globalEvents = [];

  void triggerWorldEvents(int year) {
    if (year % 5 == 0) {
      final crisis = GameEvent(
        type: 'economic_crisis',
        description: 'Une crise économique mondiale secoue les marchés',
        payload: {},
      );
      _globalEvents.add(crisis);
    }
    for (var event in _globalEvents) {
      for (var pnj in NPCManager().allNPCs) {
        pnj.reactToGlobalEvent(event);
      }
    }
  }

  List<GameEvent> getGlobalEvents() => _globalEvents;
}