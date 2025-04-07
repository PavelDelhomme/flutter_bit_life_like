import 'dart:math';

class DataService {
  static Future<List<String>> getCountries() async {
    // Données temporaires
    return Future.value(['France', 'États-Unis', 'Japon', 'Viêt Nam']);
  }
  
  static Future<List<String>> getCitiesForCountry(String country) async {
    switch (country) {
      case 'France':
        return Future.value(['Paris', 'Lyon', 'Marseille', 'Bordeaux', 'Rennes']);
      case 'États-Unis':
        return Future.value(['New York', 'Los Angeles', 'Chicago', 'Miami']);
      case 'Japon':
        return Future.value(['Tokyo', 'Osaka', 'Kyoto', 'Sapporo']);
      case 'Viêt Nam':
        return Future.value(['Hanoï', 'Hô Chi Minh-Ville', 'Da Nang', 'Can Tho']);
      default:
        return Future.value(['Ville inconnue']);
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
  
  static String getRandomCityForCountry(String country) {
    final Random random = Random();
    
    switch (country) {
      case 'France':
        return ['Paris', 'Lyon', 'Marseille', 'Bordeaux'][random.nextInt(4)];
      case 'Viêt Nam':
        return ['Hanoï', 'Hô Chi Minh-Ville', 'Da Nang', 'Can Tho'][random.nextInt(4)];
      case 'États-Unis':
        return ['New York', 'Los Angeles', 'Chicago', 'Miami'][random.nextInt(4)];
      case 'Japon':
        return ['Tokyo', 'Osaka', 'Kyoto', 'Sapporo'][random.nextInt(4)];
      default:
        return 'Ville inconnue';
    }
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
