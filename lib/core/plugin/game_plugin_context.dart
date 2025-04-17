
import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/event_service.dart';

class GamePluginContext {
  final Character mainCharacter;
  final GameStateService gameState;
  final EventService eventService;

  GamePluginContext({
    required this.mainCharacter,
    required this.gameState,
    required this.eventService,
  });
}