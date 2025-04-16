import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/services/bank/financial_service.dart';
import 'package:bitlife_like/services/save_manager.dart';
import 'package:bitlife_like/services/time_age_event/age_service.dart';
import 'package:bitlife_like/services/time_age_event/events/events_decision/event_service.dart';
import 'package:bitlife_like/services/time_age_event/time_service.dart';

import 'package:bitlife_like/plugins/plugin_manager.dart';
import 'package:bitlife_like/plugins/plugins/plugin_context.dart';
import 'package:bitlife_like/utils/random_generator.dart';
import 'package:bitlife_like/services/activity_system.dart';
import 'package:bitlife_like/services/time_age_event/age_service.dart';

class GameStateService {
  final TimeService _timeService = TimeService();
  final AgeService _ageService = AgeService(EventService.instance, FinancialService());

  Future<void> nextYear(Character character) async {
    await _ageService.ageUp(character);
    _timeService.nextYear();
    _triggerPlugins(character);
    await SaveManager.saveMainCharacter(character);
  }

  void _triggerPlugins(Character character) {
    for (final plugin in PluginManager().activePlugins) {
      plugin.onAgeUp(
        GamePluginContext(
          character: character,
          timeService: _timeService,
          eventService: EventService.instance,
          ageService: AgeService(EventService.instance, FinancialService()),
          activityManager: ActivityManager(),
          random: RandomGenerator(),
        ),
        character,
      );
    }
  }

  Future<void> resetGame() async {
    _timeService.reset();
    await SaveManager.clearAll();
  }
}