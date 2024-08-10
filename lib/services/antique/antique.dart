import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/antique.dart';

class AntiqueService {
  List<Antique>? allAntiques;

  Future<List<Antique>> loadAntiques() async {
    if (allAntiques != null) return allAntiques!;
    try {
      // Chargez le fichier JSON depuis les assets
      String jsonString = await rootBundle.loadString('assets/updated_antiques.json');
      var decoded = json.decode(jsonString);
      // Analysez le fichier JSON pour créer une liste d'objets Antique
      allAntiques = (decoded['antiques'] as List)
          .map<Antique>((json) => Antique.fromJson(json))
          .toList();
    } catch (e) {
      print("Erreur lors du chargement des antiquités : $e");
      throw Exception("Échec du chargement des antiquités");
    }
    return allAntiques!;
  }
}
