import 'package:bitlife_like/core/models/character.dart';
import 'package:bitlife_like/core/services/event_service.dart';
import 'package:bitlife_like/core/services/age_service.dart';
import 'package:bitlife_like/core/services/financial_service.dart';
import 'package:bitlife_like/core/shared/inventory_item.dart';
import 'package:flutter/material.dart';

class GameStateService {
  Character? mainCharacter;
  final EventService eventService = EventService();
  late final AgeService ageService;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GameStateService._privateConstructor() {
    ageService = AgeService(eventService, FinancialService());
  }

  static final GameStateService _instance = GameStateService._privateConstructor();
  static GameStateService get instance => _instance;

  List<InventoryItem> get inventory => character.inventory;

  void setCharacter(Character character) {
    mainCharacter = character;
  }

  Character get character {
    if (mainCharacter == null) {
      throw Exception("Character is not initialized");
    }
    return mainCharacter!;
  }

  set character(Character c) {
    mainCharacter = c;
  }
}