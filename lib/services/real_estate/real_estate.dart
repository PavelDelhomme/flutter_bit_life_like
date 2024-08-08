import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/real_estate.dart';

class RealEstateService {
  List<RealEstate>? allRealEstates; // Cache pour toutes les propriétés

  Future<void> loadAllRealEstates() async {
    if (allRealEstates != null) return; // Chargées une seule fois

    // Chargement des propriétés classiques
    String classicJson = await rootBundle.loadString('assets/real_estate.json');
    List<RealEstate> classicEstates = (json.decode(classicJson)['real_estate'] as List)
        .map<RealEstate>((json) => RealEstate.fromJson(json)).toList();

    // Chargement des propriétés exotiques
    String exoticJson = await rootBundle.loadString('assets/real_estate_exotic.json');
    List<RealEstate> exoticEstates = (json.decode(exoticJson)['real_estate_exotique'] as List)
        .map<RealEstate>((json) => RealEstate.fromJson(json)).toList();

    allRealEstates = classicEstates + exoticEstates; // Fusion des listes
  }

  // Méthode pour récupérer les propriétés par type
  Future<List<RealEstate>> getPropertiesByType(String type) async {
    await loadAllRealEstates();
    return allRealEstates!.where((estate) => estate.type == type).toList();
  }
}
