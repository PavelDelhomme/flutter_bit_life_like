import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/game_state_service.dart';
import 'package:bitlife_like/core/services/event_service.dart';

class PluginContext {
  final Character mainCharacter;
  final GameStateService gameState;
  final EventService eventService;

  PluginContext({
    required this.mainCharacter,
    required this.gameState,
    required this.eventService,
  });
}