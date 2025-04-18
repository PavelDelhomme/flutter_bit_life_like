import 'package:bitlife_like/core/services/game_state_service.dart';

class TimeService {
  void Function()? onYearPassed;

  void ageUpWorld() {
    GameStateService.instance.ageService.ageUp(character)
    GameStateService.instance.ageService.ageUpAll(characters); // Je peux faire le ageup poiur tout les character donc lesPNJ avec ceci denfaite

    if (onYearPassed != null) {
      onYearPassed!();
    }
  }

  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  void advanceByDays(int days) {
    _currentTime = _currentTime.add(Duration(days: days));
  }

  void advanceYear() => advanceByDays(365);
  void advanceMonth() => advanceByDays(30);
}
