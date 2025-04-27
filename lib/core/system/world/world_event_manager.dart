import 'dart:convert';
import 'package:flutter/services.dart';

import '../../models/event.dart';


class WorldEventManager {
  static final WorldEventManager _instance = WorldEventManager._internal();
  static WorldEventManager get instance => _instance;
  WorldEventManager._internal();

  final List<WorldEvent> _events = [];

  Future<void> loadEvents() async {
    final data = await rootBundle.loadString('assets/data/world_events.json');
    final List<dynamic> jsonData = json.decode(data);
    _events.clear();
    _events.addAll(jsonData.map((e) => WorldEvent.fromJson(e)));
  }

  List<WorldEvent> triggerRandomEvents() {
    List<WorldEvent> triggered = [];

    for (var event in _events) {
      if (event.shouldTrigger()) {
        triggered.add(event);
      }
    }

    return triggered;
  }

  List<WorldEvent> get allEvents => _events;
}
