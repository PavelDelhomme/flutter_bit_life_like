// legal_service.dart
import '../../models/person/character.dart';
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

      // Appliquer les lois rétroactivement
      if (character.criminalHistory.isNotEmpty) {
        for (var crime in character.criminalHistory) {
          crime.sentenceYears = system.calculateSentence(crime.type).toInt();
        }
      }
    }
  }

  static Future<List<LegalSystem>> loadDefaultSystems() async {
    return [
      LegalSystem(
        countryCode: 'US',
        prisonStrictness: 0.85,
        corruptionLevel: 0.4,
        sentenceMultipliers: {
          CrimeType.taxEvasion : 1.8,
          CrimeType.theft: 1.2,
          CrimeType.fraud: 1.3,
          CrimeType.assault: 1.4,
          CrimeType.drugDealing: 1.5,
          CrimeType.robbery: 1.6,
          CrimeType.murder: 2.2,
        },
        possiblePunishments: {
          CrimeType.taxEvasion: [PunishmentType.fine],
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
          CrimeType.fraud: [PunishmentType.prison],
          CrimeType.assault: [PunishmentType.prison],
          CrimeType.drugDealing: [PunishmentType.probation],
          CrimeType.robbery: [PunishmentType.communityService],
          CrimeType.murder: [PunishmentType.prison],
        },
        crimeSolvingRates: {
          CrimeType.taxEvasion: 0.65,
          CrimeType.theft: 0.65,
          CrimeType.fraud: 0.65,
          CrimeType.assault: 0.65,
          CrimeType.drugDealing: 0.65,
          CrimeType.robbery: 0.65,
          CrimeType.murder: 0.65,
        }
      ),
      LegalSystem(
          countryCode: 'FR',
          prisonStrictness: 0.85,
          corruptionLevel: 0.4,
          sentenceMultipliers: {
            CrimeType.taxEvasion : 1.8,
            CrimeType.theft: 1.2,
            CrimeType.fraud: 1.3,
            CrimeType.assault: 1.4,
            CrimeType.drugDealing: 1.5,
            CrimeType.robbery: 1.6,
            CrimeType.murder: 2.2,
          },
          possiblePunishments: {
            CrimeType.taxEvasion: [PunishmentType.fine],
            CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
            CrimeType.fraud: [PunishmentType.prison],
            CrimeType.assault: [PunishmentType.prison],
            CrimeType.drugDealing: [PunishmentType.probation],
            CrimeType.robbery: [PunishmentType.communityService],
            CrimeType.murder: [PunishmentType.prison],
          },
          crimeSolvingRates: {
            CrimeType.taxEvasion: 0.65,
            CrimeType.theft: 0.65,
            CrimeType.fraud: 0.65,
            CrimeType.assault: 0.65,
            CrimeType.drugDealing: 0.65,
            CrimeType.robbery: 0.65,
            CrimeType.murder: 0.65,
          }
      ),
      LegalSystem(
          countryCode: 'EN',
          prisonStrictness: 0.85,
          corruptionLevel: 0.4,
          sentenceMultipliers: {
            CrimeType.taxEvasion : 1.8,
            CrimeType.theft: 1.2,
            CrimeType.fraud: 1.3,
            CrimeType.assault: 1.4,
            CrimeType.drugDealing: 1.5,
            CrimeType.robbery: 1.6,
            CrimeType.murder: 2.2,
          },
          possiblePunishments: {
            CrimeType.taxEvasion: [PunishmentType.fine],
            CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
            CrimeType.fraud: [PunishmentType.prison],
            CrimeType.assault: [PunishmentType.prison],
            CrimeType.drugDealing: [PunishmentType.probation],
            CrimeType.robbery: [PunishmentType.communityService],
            CrimeType.murder: [PunishmentType.prison],
          },
          crimeSolvingRates: {
            CrimeType.taxEvasion: 0.65,
            CrimeType.theft: 0.65,
            CrimeType.fraud: 0.65,
            CrimeType.assault: 0.65,
            CrimeType.drugDealing: 0.65,
            CrimeType.robbery: 0.65,
            CrimeType.murder: 0.65,
          }
      ),
      LegalSystem(
          countryCode: 'AR',
          prisonStrictness: 0.85,
          corruptionLevel: 0.4,
          sentenceMultipliers: {
            CrimeType.taxEvasion : 1.8,
            CrimeType.theft: 1.2,
            CrimeType.fraud: 1.3,
            CrimeType.assault: 1.4,
            CrimeType.drugDealing: 1.5,
            CrimeType.robbery: 1.6,
            CrimeType.murder: 2.2,
          },
          possiblePunishments: {
            CrimeType.taxEvasion: [PunishmentType.fine],
            CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
            CrimeType.fraud: [PunishmentType.prison],
            CrimeType.assault: [PunishmentType.prison],
            CrimeType.drugDealing: [PunishmentType.probation],
            CrimeType.robbery: [PunishmentType.communityService],
            CrimeType.murder: [PunishmentType.prison],
          },
          crimeSolvingRates: {
            CrimeType.taxEvasion: 0.65,
            CrimeType.theft: 0.65,
            CrimeType.fraud: 0.65,
            CrimeType.assault: 0.65,
            CrimeType.drugDealing: 0.65,
            CrimeType.robbery: 0.65,
            CrimeType.murder: 0.65,
          }
      ),
      LegalSystem(
          countryCode: 'GR',
          prisonStrictness: 0.85,
          corruptionLevel: 0.4,
          sentenceMultipliers: {
            CrimeType.taxEvasion : 1.8,
            CrimeType.theft: 1.2,
            CrimeType.fraud: 1.3,
            CrimeType.assault: 1.4,
            CrimeType.drugDealing: 1.5,
            CrimeType.robbery: 1.6,
            CrimeType.murder: 2.2,
          },
          possiblePunishments: {
            CrimeType.taxEvasion: [PunishmentType.fine],
            CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
            CrimeType.fraud: [PunishmentType.prison],
            CrimeType.assault: [PunishmentType.prison],
            CrimeType.drugDealing: [PunishmentType.probation],
            CrimeType.robbery: [PunishmentType.communityService],
            CrimeType.murder: [PunishmentType.prison],
          },
          crimeSolvingRates: {
            CrimeType.taxEvasion: 0.65,
            CrimeType.theft: 0.65,
            CrimeType.fraud: 0.65,
            CrimeType.assault: 0.65,
            CrimeType.drugDealing: 0.65,
            CrimeType.robbery: 0.65,
            CrimeType.murder: 0.65,
          }
      ),
      LegalSystem(
          countryCode: 'RU',
          prisonStrictness: 0.85,
          corruptionLevel: 0.4,
          sentenceMultipliers: {
            CrimeType.taxEvasion : 1.8,
            CrimeType.theft: 1.2,
            CrimeType.fraud: 1.3,
            CrimeType.assault: 1.4,
            CrimeType.drugDealing: 1.5,
            CrimeType.robbery: 1.6,
            CrimeType.murder: 2.2,
          },
          possiblePunishments: {
            CrimeType.taxEvasion: [PunishmentType.fine],
            CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
            CrimeType.fraud: [PunishmentType.prison],
            CrimeType.assault: [PunishmentType.prison],
            CrimeType.drugDealing: [PunishmentType.probation],
            CrimeType.robbery: [PunishmentType.communityService],
            CrimeType.murder: [PunishmentType.prison],
          },
          crimeSolvingRates: {
            CrimeType.taxEvasion: 0.65,
            CrimeType.theft: 0.65,
            CrimeType.fraud: 0.65,
            CrimeType.assault: 0.65,
            CrimeType.drugDealing: 0.65,
            CrimeType.robbery: 0.65,
            CrimeType.murder: 0.65,
          }
      )
    ];
  }
}
