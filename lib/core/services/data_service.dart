import 'dart:convert';
import 'dart:math';

import 'package:bitlife_like/core/services/pnj_manager.dart';
import 'package:flutter/services.dart';

import '../../core/models/relationship.dart';
import '../models/character.dart';
import '../shared/tax_system.dart';

class DataService {
  static final Random _random = Random();
  static final Map<String, List<String>> _cachedCities = {};
  static List<String> _cachedCountries = [];
  static Map<String, double> _cachedTaxRates = {};

  static Future<void> preloadCities() async {
    final countries = await getCountries();
    for (final country in countries) {
      _cachedCities[country] = await getCitiesForCountry(country);
    }
  }

  static Future<void> _preloadTaxRates() async {
    final String data = await rootBundle.loadString('assets/data/financial/tax_data.json');
    final Map<String, dynamic> jsonData = json.decode(data);
    _cachedTaxRates = {
      for (var entry in jsonData.entries)
        entry.key: (entry.value['corporateTax'] as num).toDouble()
    };
  }

  static List<String> getCitiesForCountrySync(String country) {
    return _cachedCities[country] ?? [];
  }

  static Future<List<String>> getCountries() async {
    final String data = await rootBundle.loadString('assets/data/countries.json');
    final Map<String, dynamic> jsonData = json.decode(data);
    return jsonData.keys.toList();
  }


  static Future<List<String>> getCitiesForCountry(String country) async {
    try {
      final String data = await rootBundle.loadString('assets/data/cities/$country.json');
      final Map<String, dynamic> jsonData = json.decode(data);
      return List<String>.from(jsonData['cities']);
    } catch (_) {
      return ['Ville inconnue'];
    }
  }

  static Future<Map<String, List<Map<String, dynamic>>>> loadCompanyCatalog() async {
    final String data = await rootBundle.loadString('assets/data/company_catalog.json');
    final Map<String, dynamic> jsonData = json.decode(data);
    return jsonData.map((key, value) => MapEntry(
        key, List<Map<String, dynamic>>.from(value)
    ));
  }

  static Future<TaxSystem> loadTaxSystem(String country) async {
    final String data = await rootBundle.loadString('assets/data/financial/tax_data.json');
    final Map<String, dynamic> jsonData = json.decode(data);

    if (!jsonData.containsKey(country)) {
      throw Exception('Aucune donnée fiscale trouvée pour le pays : $country');
    }

    return TaxSystem.fromJson(jsonData[country], country);
  }

  static String getRandomName(String gender) {
    final Random random = Random();
    final List<String> maleNames = ['Thomas', 'Nicolas', 'Lucas', 'Léo', 'Nguyen', 'Pierre', 'Hugo'];
    final List<String> femaleNames = ['Emma', 'Jade', 'Louise', 'Chloé', 'Mai', 'Alice', 'Sarah'];

    return gender == 'Homme'
        ? maleNames[random.nextInt(maleNames.length)]
        : femaleNames[random.nextInt(femaleNames.length)];
  }


  static String getRandomCountry() {
    if (_cachedCountries.isEmpty) return 'France';
    return _cachedCountries[_random.nextInt(_cachedCountries.length)];
  }

  static Future<String> getRandomCityForCountry(String country) async {
    final cities = await getCitiesForCountry(country);
    return cities.isNotEmpty
        ? cities[_random.nextInt(cities.length)]
        : 'Ville inconnue';
  }


  static double getTaxRateForCountry(String country) {
    return _cachedTaxRates[country] ?? 0.30;
  }

  static Future<String> getRandomCityForCountryAsync(String country) async {
    final cities = await getCitiesForCountry(country);
    if (cities.isEmpty) return 'Inconnu';
    return cities[Random().nextInt(cities.length)];
  }

  static String calculateZodiacSign(DateTime birthdate) {
    int month = birthdate.month;
    int day = birthdate.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Bélier';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taureau';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gémeaux';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Lion';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Vierge';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Balance';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return 'Scorpion';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return 'Sagittaire';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return 'Capricorne';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return 'Verseau';
    return 'Poissons';
  }


  static Character generateFamilyMember(Character mainCharacter, RelationshipType type) {
    final random = Random();
    final ageDifference = switch(type) {
      RelationshipType.parent => 20 + random.nextInt(10),
      RelationshipType.child => -(18 + random.nextInt(10)),
      _ => 0
    };
    final birthdate = mainCharacter.birthdate.add(Duration(days: ageDifference * 365));

    final familyMember = Character(
      fullName: '${mainCharacter.fullName} ${_getFamilySuffix(type)}',
      gender: random.nextBool() ? 'Homme' : 'Femme',
      country: mainCharacter.country,
      city: mainCharacter.city,
      birthdate: birthdate,
      zodiacSign: DataService.calculateZodiacSign(birthdate), // Ajouté ici
      stats: PnjManager.generateInitialStats(), // Référence corrigée
      isPNJ: true,
    );

    final relId = 'rel_${mainCharacter.id}_${familyMember.id}';

    mainCharacter.relationships.add(Relationship(
      id: relId,
      characterId: mainCharacter.id,
      targetId: familyMember.id,
      type: type,
      strength: 0.8,
      status: RelationshipStatus.excellent,
    ));

    return familyMember;
  }

  static String _getFamilySuffix(RelationshipType type) {
    return const {
      RelationshipType.parent: 'Parent',
      RelationshipType.sibling: 'Frère/Soeur',
      RelationshipType.child: 'Enfant',
    }[type] ?? '';
  }

}


