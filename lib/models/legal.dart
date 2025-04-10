
import 'dart:math';

import 'work/career.dart';
import 'person/character.dart';

enum CrimeType {
  taxEvasion,
  theft,
  fraud,
  assault,
  drugDealing,
  robbery,
  murder,
  illegalActivity,
}

enum PunishmentType {
  fine,
  probation,
  communityService,
  prison
}

class Crime {
  final String id;
  final CrimeType type;
  final DateTime date;
  final String description;
  final PunishmentType? punishment;
  int? sentenceYears;
  final double? fine;
  final bool isSolved;
  
  Crime({
    required this.id,
    required this.type,
    required this.date,
    required this.description,
    this.punishment,
    this.sentenceYears,
    this.fine,
    this.isSolved = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'date': date.toIso8601String(),
      'description': description,
      'punishment': punishment?.toString(),
      'sentenceYears': sentenceYears,
      'fine': fine,
      'isSolved': isSolved,
    };
  }
  
  factory Crime.fromJson(Map<String, dynamic> json) {
    return Crime(
      id: json['id'],
      type: CrimeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => CrimeType.taxEvasion
      ),
      date: DateTime.parse(json['date']),
      description: json['description'],
      punishment: json['punishment'] != null 
          ? PunishmentType.values.firstWhere(
              (e) => e.toString() == json['punishment'],
              orElse: () => PunishmentType.fine
            )
          : null,
      sentenceYears: json['sentenceYears'],
      fine: json['fine'],
      isSolved: json['isSolved'],
    );
  }
}


class LegalSystem {
  final String countryCode;
  final double prisonStrictness; // 0.0 (laxiste) à 1.0 (strict)
  final double corruptionLevel; // 0.0 (propre) à 1.0 (corrompu)
  final Map<CrimeType, double> sentenceMultipliers;
  final Map<CrimeType, List<PunishmentType>> possiblePunishments;
  final Map<CrimeType, double> crimeSolvingRates;
  final double auditProbability;
  final double inheritanceTaxRate;

  static const Map<CrimeType, int> _baseSentences = {
    CrimeType.taxEvasion: 2,
    CrimeType.theft: 1,
    CrimeType.fraud: 3,
    CrimeType.assault: 2,
    CrimeType.drugDealing: 5,
    CrimeType.robbery: 7,
    CrimeType.murder: 15,
  };

  LegalSystem({
    required this.countryCode,
    required this.prisonStrictness,
    required this.corruptionLevel,
    required this.sentenceMultipliers,
    required this.possiblePunishments,
    required this.crimeSolvingRates,
    this.auditProbability = 0.05,
    this.inheritanceTaxRate = 0.3,
  });

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'prisonStrictness': prisonStrictness,
      'corruptionLevel': corruptionLevel,
      'sentenceMultipliers': sentenceMultipliers.map((k, v) => MapEntry(k.toString(), v)),
      'possiblePunishments': possiblePunishments.map((k, v) => MapEntry(
          k.toString(),
          v.map((p) => p.toString()).toList()
      )),
      'crimeSolvingRates': crimeSolvingRates.map((k, v) => MapEntry(k.toString(), v)),
    };
  }

  factory LegalSystem.fromJson(Map<String, dynamic> json) {
    return LegalSystem(
      countryCode: json['countryCode'],
      prisonStrictness: json['prisonStrictness'],
      corruptionLevel: json['corruptionLevel'],
      sentenceMultipliers: json['sentenceMultipliers'].map<String, double>(
            (k, v) => MapEntry(CrimeType.values.firstWhere((e) => e.toString() == k), v),
      ),
      possiblePunishments: json['possiblePunishments'].map<CrimeType, List<PunishmentType>>(
            (k, v) => MapEntry(
            CrimeType.values.firstWhere((e) => e.toString() == k),
            (v as List).map((p) => PunishmentType.values.firstWhere((e) => e.toString() == p)).toList()
        ),
      ),
      crimeSolvingRates: json['crimeSolvingRates'].map<String, double>(
            (k, v) => MapEntry(CrimeType.values.firstWhere((e) => e.toString() == k), v),
      ),
    );
  }


  static Future<List<LegalSystem>> loadDefaultSystems() async {
    return [
      LegalSystem(
        countryCode: 'FR',
        prisonStrictness: 0.7,
        corruptionLevel: 0.2,
        auditProbability: 0.07,
        inheritanceTaxRate: 0.35,
        sentenceMultipliers: {
          CrimeType.taxEvasion: 1.5,
          CrimeType.murder: 2.0,
        },
        possiblePunishments: {
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
        },
        crimeSolvingRates: {
          CrimeType.robbery: 0.6,
        },
      ),
      LegalSystem(
        countryCode: 'US',
        prisonStrictness: 0.7,
        corruptionLevel: 0.2,
        auditProbability: 0.07,
        inheritanceTaxRate: 0.35,
        sentenceMultipliers: {
          CrimeType.taxEvasion: 1.5,
          CrimeType.murder: 2.0,
        },
        possiblePunishments: {
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
        },
        crimeSolvingRates: {
          CrimeType.robbery: 0.6,
        },
      ),
      LegalSystem(
        countryCode: 'EN',
        prisonStrictness: 0.7,
        corruptionLevel: 0.2,
        auditProbability: 0.07,
        inheritanceTaxRate: 0.35,
        sentenceMultipliers: {
          CrimeType.taxEvasion: 1.5,
          CrimeType.murder: 2.0,
        },
        possiblePunishments: {
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
        },
        crimeSolvingRates: {
          CrimeType.robbery: 0.6,
        },
      ),
      LegalSystem(
        countryCode: 'AR',
        prisonStrictness: 0.7,
        corruptionLevel: 0.2,
        auditProbability: 0.07,
        inheritanceTaxRate: 0.35,
        sentenceMultipliers: {
          CrimeType.taxEvasion: 1.5,
          CrimeType.murder: 2.0,
        },
        possiblePunishments: {
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
        },
        crimeSolvingRates: {
          CrimeType.robbery: 0.6,
        },
      ),
      LegalSystem(
        countryCode: 'GR',
        prisonStrictness: 0.7,
        corruptionLevel: 0.2,
        auditProbability: 0.07,
        inheritanceTaxRate: 0.35,
        sentenceMultipliers: {
          CrimeType.taxEvasion: 1.5,
          CrimeType.murder: 2.0,
        },
        possiblePunishments: {
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
        },
        crimeSolvingRates: {
          CrimeType.robbery: 0.6,
        },
      ),
      LegalSystem(
        countryCode: 'RU',
        prisonStrictness: 0.7,
        corruptionLevel: 0.2,
        auditProbability: 0.07,
        inheritanceTaxRate: 0.35,
        sentenceMultipliers: {
          CrimeType.taxEvasion: 1.5,
          CrimeType.murder: 2.0,
        },
        possiblePunishments: {
          CrimeType.theft: [PunishmentType.fine, PunishmentType.communityService],
        },
        crimeSolvingRates: {
          CrimeType.robbery: 0.6,
        },
      ),
    ];
  }

  double calculateSentence(CrimeType crime) {
    final baseYears = _baseSentences[crime] ?? 1;
    return baseYears * sentenceMultipliers[crime]! * prisonStrictness;
  }

  bool attemptCrime(Character character, CrimeType crimeType) {
    // Chance de réussite basée sur compétences et caractère aléatoire
    double baseSuccessRate = 0.7;
    double successRate = baseSuccessRate - (character.hasCriminalRecord ? 0.2 : 0);

    bool success = Random().nextDouble() < successRate;
    if (!success) {
      // Crime échoué - arrestation immédiate
      processCrimeAndPunishment(character, crimeType);
      return false;
    }

    // Crime réussi mais possibilité d'être attrapé plus tard
    double solvingRate = crimeSolvingRates[crimeType] ?? 0.5;
    bool caughtLater = Random().nextDouble() < solvingRate;

    if (caughtLater) {
      // Délai avant arrestation
      Future.delayed(Duration(seconds: 30), () {
        processCrimeAndPunishment(character, crimeType);
      });
    }

    return true;
  }

  void processCrimeAndPunishment(Character character, CrimeType crimeType) {
    character.hasCriminalRecord = true;

    // Sélection aléatoire de la punition parmi les possibles
    List<PunishmentType> punishments = possiblePunishments[crimeType] ?? [PunishmentType.fine];
    PunishmentType punishment = punishments[Random().nextInt(punishments.length)];

    // Application de la punition
    switch (punishment) {
      case PunishmentType.fine:
        double fineAmount = character.calculateTotalIncome() * 0.3;
        character.money -= fineAmount;
        character.addLifeEvent("Condamné(e) pour ${crimeType.toString()} avec une amende de \$${fineAmount.toStringAsFixed(2)}");
        break;
      case PunishmentType.probation:
        character.addLifeEvent("Condamné(e) pour ${crimeType.toString()} avec une mise à l'épreuve de 2 ans");
        break;
      case PunishmentType.communityService:
        character.addLifeEvent("Condamné(e) pour ${crimeType.toString()} avec 200 heures de travaux d'intérêt général");
        break;
      case PunishmentType.prison:
        int years = 1 + Random().nextInt(10);
        character.yearsInPrison += years;
        character.addLifeEvent("Condamné(e) pour ${crimeType.toString()} à $years ans de prison");
        if (character.career != null) {
          character.career!.status = EmploymentStatus.fired;
        }
        break;
    }

    Crime crime = Crime(
      id: 'crime_${DateTime.now().millisecondsSinceEpoch}',
      type: crimeType,
      date: DateTime.now(),
      description: "A commis un crime de type ${crimeType.toString()}",
      punishment: punishment,
      sentenceYears: punishment == PunishmentType.prison ? character.yearsInPrison : null,
      fine: punishment == PunishmentType.fine ? character.calculateTotalIncome() * 0.3 : null,
      isSolved: true,
    );

    character.criminalHistory.add(crime);
  }

  bool attemptBribe(Character character, double amount) {
    // Chance de réussite du pot-de-vin
    double successRate = 0.3 + (amount / 10000) * (1 - corruptionLevel);
    successRate = min(successRate, 0.8);

    bool success = Random().nextDouble() < successRate;

    if (success) {
      character.money -= amount;
      character.addLifeEvent("A soudoyé un officiel avec \$${amount.toStringAsFixed(2)} et a évité des poursuites");
      return true;
    } else {
      // Le pot-de-vin a échoué et aggrave la situation
      character.money -= amount;
      character.addLifeEvent("A tenté de soudoyer un officiel avec \$${amount.toStringAsFixed(2)} et a été pris sur le fait");

      // Ajouter un nouveau crime pour tentative de corruption
      processCrimeAndPunishment(character, CrimeType.fraud);
      return false;
    }
  }

  void performAnnualAudit(Character character) {
    if (character.declaredIncome >= character.actualIncome) return;

    final discrepancy = (character.actualIncome - character.declaredIncome) / character.actualIncome;

    final auditChance = auditProbability + discrepancy * discrepancy; // Plus l'écart est grand, plus le risque augmente

    if (Random().nextDouble() < auditChance) {
      final fineAmount = (character.actualIncome - character.declaredIncome) * inheritanceTaxRate; // Amende basée sur le taux d'héritage
      character.money -= fineAmount;

      character.addLifeEvent(
          "Audit fiscal : Une fraude a été détectée. Amende de \$${fineAmount.toStringAsFixed(2)}."
      );

      if (discrepancy > inheritanceTaxRate * Random().nextDouble()) {
        processCrimeAndPunishment(character, CrimeType.taxEvasion);
      }
    }
  }

  void processCrime(CrimeType crimeType) {

  }

}


