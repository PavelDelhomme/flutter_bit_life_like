import 'package:bitlife_like/models/person/character.dart';
import 'package:bitlife_like/services/activity_system.dart';
import 'package:bitlife_like/services/bank/financial_service.dart';
import 'package:bitlife_like/services/time_age_event/age_service.dart';
import 'package:bitlife_like/services/time_age_event/events/events_decision/event_service.dart';
import 'package:bitlife_like/services/time_age_event/time_service.dart';
import 'package:bitlife_like/utils/random_generator.dart';
import 'package:bitlife_like/plugins/plugins/plugin_context.dart';

GamePluginContext buildGamePluginContext(Character character) {
  return GamePluginContext(
    character: character,
    timeService: TimeService(),
    eventService: EventService.instance,
    activityManager: ActivityManager(),
    ageService: AgeService(EventService.instance, FinancialService()),
    random: RandomGenerator(),
  );
}
