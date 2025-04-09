import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person/character.dart';

class SaveManager {
  static late Box<Character> _mainCharacterBox;
  static late Box<Character> _pnjBox;

  static Future<void> initialize() async {
    _mainCharacterBox = await Hive.openBox<Character>('main_characters');
    _pnjBox = await Hive.openBox<Character>('pnjs');
  }

  static Future<void> saveMainCharacter(Character character) async {
    await _mainCharacterBox.put('current', character);
  }

  static Future<Character?> loadMainCharacter() async {
    return _mainCharacterBox.get('current');
  }

  static Future<void> savePNJs(List<Character> pnjs) async {
    await _pnjBox.putAll(Map.fromEntries(
        pnjs.map((p) => MapEntry(p.id, p))
    ));
  }

  static Future<List<Character>> loadPNJs(List<String> ids) async {
    final pnjs = <Character>[];

    for (final id in ids) {
      final pnj = _pnjBox.get(id);
      if (pnj != null) pnjs.add(pnj);
    }

    return pnjs;
  }


  static Future<void> clearAll() async {
    await _mainCharacterBox.clear();
    await _pnjBox.clear();
  }
}