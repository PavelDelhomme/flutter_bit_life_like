import 'package:bitlife_like/services/time_age_event/events/events_decision/event_service.dart';

class TimeService {
  static final TimeService _instance = TimeService._internal();
  int _currentYear = 2024;
  int _currentDay = 0;

  TimeService._internal();

  factory TimeService() => _instance;

  int get currentYear => _currentYear;
  int get currentDay => _currentDay;

  void nextYear() {
    _currentYear++;
    EventService.instance.triggerYearlyEvents(_currentYear);
  }

  void advanceTime({int days = 1}) {
    _currentDay += days;
    EventService.instance.triggerOnTickEvents();
  }

  void reset() {
    _currentYear = 2024;
    _currentDay = 0;
  }
}