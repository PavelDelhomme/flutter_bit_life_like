import 'package:bitlife_like/core/services/game_state_service.dart';

import '../system/world/world_engine.dart';

class TimeService {
  void Function()? onYearPassed;

  Future<void> ageUpWorld() async {
    final gameState = GameStateService.instance;
    await gameState.ageService.ageUp(gameState.character);
    gameState.ageService.ageUpAll(WorldEngine.instance.allPNJ);

    onYearPassed?.call();
  }


  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  void advanceByDays(int days) {
    _currentTime = _currentTime.add(Duration(days: days));
  }

  void advanceYear() => advanceByDays(365);
  void advanceMonth() => advanceByDays(30);
}
