import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/event_service.dart';

class GameStateService {
  Character? mainCharacter;
  final EventService eventService = EventService();

  GameStateService._privateConstructor();

  static final GameStateService _instance = GameStateService._privateConstructor();
  factory GameStateService() => _instance;

  void setCharacter(Character character) {
    mainCharacter = character;
  }

  Character get character {
    if (mainCharacter == null) {
      throw Exception("Character is not initialized");
    }
    return mainCharacter!;
  }
}