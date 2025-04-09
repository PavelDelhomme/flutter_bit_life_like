// pnj_manager.dart
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/character.dart';
import 'data_service.dart';

class PnjManager {
  static Future<List<Character>> loadBatch(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    return ids.map((id) {
      final json = prefs.getString(id);
      return json != null ? Character.fromJson(jsonDecode(json)) : null;
    }).whereType<Character>().toList();
  }

  static Future<void> saveBatch(List<Character> pnjs) async {
    final prefs = await SharedPreferences.getInstance();
    final data = Map.fromEntries(
        pnjs.map((p) => MapEntry(p.id, jsonEncode(p.toJson())))
    );
    prefs.setStringList(pnjs.map((p) => p.id).toList(), data);
  }

  static Character generateRandomPnj() {
    return Character(
      fullName: DataService.getRandomName(Random().nextBool() ? 'Homme' : 'Femme'),
      gender: Random().nextBool() ? 'Homme' : 'Femme',
      country: DataService.getRandomCountry(),
      // ... autres paramètres avec valeurs aléatoires
    );
  }

  static void simulatePnjLife(Character pnj) {
    // Logique d'évolution autonome
    if (Random().nextDouble() < 0.3) {
      pnj.ageUp();
      pnj.stats['happiness'] = (pnj.stats['happiness']! + Random().nextInt(10) - 5).clamp(0, 100);
    }
  }
}
