import 'dart:math';

import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/pnj_manager.dart';
import 'package:bitlife_like/core/services/time_service.dart';
import 'package:bitlife_like/core/system/event/event_manager.dart';
import 'package:bitlife_like/core/system/world/npc_manager.dart';

import '../../services/pnj_action_service.dart';
import '../game_event.dart';

class WorldEngine {
  static final WorldEngine _instance = WorldEngine._internal();
  static WorldEngine get instance => _instance;
  WorldEngine._internal();

  final List<Character> _allPNJ = [];
  final TimeService _timeService = TimeService();

  void initializeWorld() {
    _generateInitialPopulation();
    _timeService.onYearPassed = _onYearPassed;
    NPCManager().allNPCs.clear();
    NPCManager().allNPCs.addAll(_allPNJ);
  }

  void _generateInitialPopulation() {
    for (int i = 0; i < 200; i++) {
      final newPNJ = PnjManager.generatePNJ();
      _allPNJ.add(newPNJ);
    }
  }

  void _onYearPassed() {
    final actionService = PnjActionService();

    final year = _timeService.currentTime.year;

    // Vieillissement des PNJs
    GameStateService.instance.ageService.ageUpAll(_allPNJ);

    // Evenement mondiaux
    EventManager().triggerWorldEvents(year);

    // Application aux pnj (propagation)
    for (final pnj in _allPNJ.where((p) => p.isAlive)) {
      _applyWorldEventsToPNJ(pnj, EventManager().getGlobalEvents());
      actionService.performDailyActions(pnj);
    }

    _maintainPopulation();
  }

  void _applyWorldEventsToPNJ(Character pnj, List<GameEvent> events) {
    for (final event in events) {
      if (event.type == "economic_crisis" && Random().nextDouble() < 0.5) {
        pnj.stats['happiness'] = (pnj.stats['happiness']! - 10).clamp(0, 100);
        pnj.addLifeEvent("J'ai été affecté·e par une crise économique mondiale.");
      }
      // autres types : guerre, loi, pandémie, etc. // Cela se fera aussi en fonction des plugin activé donc a voir en attente
    }
  }

  List<Character> getNearbyPNJ(Character player) {
    return _allPNJ.where((p) => p.city == player.city && p.isAlive).toList();
  }

  void _maintainPopulation() {
    _allPNJ.removeWhere((pnj) => !pnj.isAlive);
    while (_allPNJ.length < 200) {
      _allPNJ.add(PnjManager.generatePNJ());
    }
  }

  List<Character> get allPNJ => _allPNJ;
}