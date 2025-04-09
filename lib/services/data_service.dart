import 'dart:math';

class DataService {
  static Future<List<String>> getCountries() async {
    // Données temporaires
    return Future.value(['France', 'États-Unis', 'Japon', 'Viêt Nam']);
  }
  
  static Future<List<String>> getCitiesForCountry(String country) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulation de latence
    switch (country) {
      case 'France':
        return ['Paris', 'Lyon', 'Marseille', 'Bordeaux', 'Rennes'];
      case 'États-Unis':
        return ['New York', 'Los Angeles', 'Chicago', 'Miami'];
      case 'Japon':
        return ['Tokyo', 'Osaka', 'Kyoto', 'Sapporo'];
      case 'Viêt Nam':
        return ['Hanoï', 'Hô Chi Minh-Ville', 'Da Nang', 'Can Tho'];
      default:
        return ['Ville inconnue'];
    }
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
    final countries = ['France', 'États-Unis', 'Japon', 'Viêt Nam'];
    return countries[Random().nextInt(countries.length)];
  }

  static Future<String> getRandomCityForCountry(String country) async {
    final cities = await getCitiesForCountry(country);
    return cities.isNotEmpty
        ? cities[Random().nextInt(cities.length)]
        : 'Inconnu';
  }


  static final Map<String, double> _countryTaxRates = {
    'France': 0.30,
    'États-Unis': 0.28,
    'Japon': 0.35,
    'Viêt Nam': 0.25,
  };

  static double getTaxRateForCountry(String country) {
    return _countryTaxRates[country] ?? 0.30; // valeur par défaut
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
}
