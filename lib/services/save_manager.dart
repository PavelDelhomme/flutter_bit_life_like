import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';


class SaveManager {
  static const _saveKey = 'character_save';


  static Future<void> saveCharacter(Character character) async {
    final json = character.toJson();
  // Utiliser shared_preferences ou un package de stockage
    // Exemple avec shared_preferences :
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_saveKey, json);

  }
  Future<Character?> loadCharacter(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('save_$id');

    if (jsonString == null) return null;

    final jsonData = jsonDecode(jsonString);
    final characterJson = jsonData['character'];

    return Character.fromJson(characterJson)..isPNJ = characterJson['isPNJ'] ?? false;
  }
}