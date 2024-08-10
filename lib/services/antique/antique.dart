import 'dart:convert';
import 'package:flutter/services.dart';
import '../../Classes/objects/antique.dart';

class AntiqueService {
  Future<List<Antique>> loadAntiques() async {
    try {
      String jsonString = await rootBundle.loadString('assets/antiques.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);
      List<Antique> antiques = (jsonResponse['antiques'] as List<dynamic>)
          .map((json) => Antique.fromJson(json))
          .toList();
      return antiques;
    } catch (e) {
      throw Exception('Failed to load antiques: $e');
    }
  }
}
