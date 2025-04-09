// legal_service.dart
import '../../models/character.dart';
import '../../models/legal.dart';
import '../data_service.dart';

class LegalService {
  static final Map<String, LegalSystem> _systems = {};

  static void initialize(List<LegalSystem> systems) {
    _systems.addEntries(systems.map((s) => MapEntry(s.countryCode, s)));
  }

  static LegalSystem? getSystem(String countryCode) {
    return _systems[countryCode];
  }

  static void applyCountryLaw(Character character) {
    final system = getSystem(character.country);
    if (system != null) {
      character.legalSystem = system;
      character.taxRate = DataService.getTaxRateForCountry(character.country);
    }
  }
}
