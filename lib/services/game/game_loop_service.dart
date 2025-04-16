import 'dart:async';
import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/plugins/plugin_manager.dart';
import 'package:bitlife_like/plugins/plugins/plugin_context.dart';
import 'package:bitlife_like/services/activity_system.dart';
import 'package:bitlife_like/services/bank/financial_service.dart';
import 'package:bitlife_like/services/time_age_event/time_service.dart';
import 'package:bitlife_like/services/time_age_event/events/events_decision/event_service.dart';
import 'package:bitlife_like/utils/random_generator.dart';

import 'package:bitlife_like/services/time_age_event/age_service.dart';

class GameLoopService {
  Timer? _loopTimer;

  void startTicking(Character character, {Duration interval = const Duration(seconds: 5)}) {
    _loopTimer?.cancel();
    _loopTimer = Timer.periodic(interval, (_) {
      _onTick(character);
    });
  }

  void stopTicking() {
    _loopTimer?.cancel();
    _loopTimer = null;
  }

  void _onTick(Character character) {
    EventService.instance.triggerOnTickEvents();

    for (final plugin in PluginManager().activePlugins) {
      plugin.onTick(
        GamePluginContext(
          character: character,
          timeService: TimeService(),
          eventService: EventService.instance,
          activityManager: ActivityManager(),
          random: RandomGenerator(),
          ageService: AgeService(EventService.instance, FinancialService()),
        )
      );
    }
  }
}