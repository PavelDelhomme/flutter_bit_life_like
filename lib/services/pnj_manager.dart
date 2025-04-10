import 'dart:math';
import 'package:bitlife_like/models/legal.dart';
import 'package:bitlife_like/services/legal/legal_service.dart';

import '../models/person/character.dart';
import '../models/person/relationship.dart';
import 'data_service.dart';

class PnjManager {
  static final _random = Random();

  static Character generateFamilyMember(Character mainCharacter, RelationshipType type) {
    final ageDifference = switch (type) {
      RelationshipType.parent => 18 + Random().nextInt(27),
      RelationshipType.sibling => Random().nextInt(5) - 2,
      _ => 0
    };


    final birthdate = mainCharacter.birthdate.subtract(Duration(days: ageDifference * 365));


    final familyMember = Character(
      fullName: '${mainCharacter.fullName} ${_getFamilySuffix(type)}',
      gender: Random().nextBool() ? 'Homme' : 'Femme',
      country: mainCharacter.country,
      city: mainCharacter.city,
      birthdate: birthdate,
      zodiacSign: DataService.calculateZodiacSign(birthdate),
      stats: _generateFamilyStats(mainCharacter),
      isPNJ: true,
    );


    // Ajouter une relation bidirectionnelle
    final relationshipId = 'rel_${mainCharacter.id}_${familyMember.id}';


    mainCharacter.relationships.add(Relationship(
      id: relationshipId,
      characterId: mainCharacter.id,
      targetId: familyMember.id,
      type: type,
      strength: Random().nextDouble(),
    ));

    familyMember.relationships.add(Relationship(
      id: relationshipId,
      characterId: familyMember.id,
      targetId: mainCharacter.id,
      type: _getInverseRelationshipType(type),
      strength: Random().nextDouble(),
    ));

    return familyMember;

  }

  static RelationshipType _getInverseRelationshipType(RelationshipType type) {
    switch (type) {
      case RelationshipType.parent:
        return RelationshipType.child;
      case RelationshipType.child:
        return RelationshipType.parent;
      case RelationshipType.sibling:
        return RelationshipType.sibling;
      default:
        return RelationshipType.friend; // Par défaut, retourne "ami"
    }
  }

  static Map<String, double> _generateFamilyStats(Character mainCharacter) {
    return {
      'health': (mainCharacter.stats['health']! * _random.nextDouble()).clamp(30.0, 100.0),
      'happiness': 70.0 + _random.nextDouble() * 30.0,
      'intelligence': mainCharacter.stats['intelligence']! * _random.nextDouble(),
      'appearance': mainCharacter.stats['appearance']! * _random.nextDouble(),
    };
  }

  static Character generatePNJ() {
    final country = DataService.getRandomCountry();
    final cities = DataService.getCitiesForCountrySync(country);
    final birthdate = _generateBirthdate();
    return Character(
      fullName: DataService.getRandomName(_random.nextBool() ? 'Homme' : 'Femme'),
      gender: _random.nextBool() ? 'Homme' : 'Femme',
      country: country,
      city: cities.isNotEmpty ? cities[_random.nextInt(cities.length)] : 'Inconnu',
      birthdate: birthdate,
      stats: generateInitialStats(),
      isPNJ: true,
      taxRate: DataService.getTaxRateForCountry(country),
      zodiacSign: DataService.calculateZodiacSign(birthdate),
    )..legalSystem = LegalService.getSystem(country);
  }

  static DateTime _generateBirthdate() {
    final now = DateTime.now();
    return DateTime(now.year - _random.nextInt(50) - 18,
        _random.nextInt(12) + 1,
        _random.nextInt(28) + 1);
  }


  static Map<String, double> generateInitialStats() {
    return {
      'health': (_random.nextDouble() * 80 + 20).clamp(0.0, 100.0),
      'happiness': (_random.nextDouble() * 80 + 20).clamp(0.0, 100.0),
      'intelligence': (_random.nextDouble() * 80 + 20).clamp(0.0, 100.0),
      'appearance': (_random.nextDouble() * 80 + 20).clamp(0.0, 100.0),
    };
  }

  static Future<void> simulatePnjLife(Character pnj) async {
    if (pnj.legalSystem == null) {
      LegalService.applyCountryLaw(pnj);
    }

    // Veillissement
    pnj.ageUp();

    if (Random().nextDouble() < 0.25) {
      final crimeTypes = CrimeType.values;
      final randomCrime = crimeTypes[Random().nextInt(crimeTypes.length)];
      pnj.legalSystem!.attemptCrime(pnj, randomCrime);
    }
    if (Random().nextDouble() < 0.3) {
      pnj.stats['happiness'] = (pnj.stats['happiness']! + Random().nextInt(10) - 5).clamp(0, 100);
    }

    // Mise a jour automatique
    await pnj.save();
  }

  static String _getFamilySuffix(RelationshipType type) {
    return const {
      RelationshipType.parent: 'Parent',
      RelationshipType.sibling: 'Frère/Soeur',
      RelationshipType.child: 'Enfant',
    }[type] ?? '';
  }
  static List<Character> generateComplexFamily(Character mainCharacter) {
    final family = <Character>[];
    final random = Random();

    // Parents principaux (avec 15% de chance de famille monoparentale)
    if (random.nextDouble() < 0.85) {
      family.addAll([
        _generateParent(mainCharacter),
        _generateParent(mainCharacter, sameGender: random.nextDouble() < 0.1) // 10% chance couple same-sex
      ]);
    } else {
      family.add(_generateParent(mainCharacter));
    }

    // Grands-parents (40% de chance)
    if (random.nextDouble() < 0.4) {
      family.addAll(family.whereType<Character>().expand((parent) => [
        _generateGrandParent(parent),
        _generateGrandParent(parent)
      ]));
    }

    // Oncles/tantes (50% de chance)
    if (random.nextDouble() < 0.5) {
      family.addAll(family.whereType<Character>().map(_generateSibling));
    }

    // Cousins (30% de chance si oncles/tantes existent)
    if (random.nextDouble() < 0.3 && family.any((c) => c.relationships.any((r) => r.type == RelationshipType.sibling))) {
      family.addAll(family.whereType<Character>().map(_generateCousin));
    }

    return family;
  }

  static Character _generateParent(Character child, {bool sameGender = false}) {
    final parent = generateFamilyMember(child, RelationshipType.parent);
    if (sameGender) parent.gender = child.gender;

    final relationshipId = 'rel_${parent.id}_${child.id}';

    return parent..relationships.add(Relationship(
        characterId: parent.id,
        id: relationshipId,
        type: RelationshipType.child,
        targetId: child.id,
        strength: 0.9
    ));
  }

  static Character _generateGrandParent(Character parent) {
    final grandParent = generateFamilyMember(parent, RelationshipType.parent)
      ..birthdate = parent.birthdate.subtract(Duration(days: 365 * 20));

    final relationshipId = 'rel_${grandParent.id}_${parent.id}';

    grandParent.relationships.add(Relationship(
        id: relationshipId,
        characterId: grandParent.id,
        type: RelationshipType.child,
        targetId: parent.id,
        strength: 0.8
    ));

    return grandParent;
  }

  static Character _generateSibling(Character character) {
    final sibling = generateFamilyMember(character, RelationshipType.sibling);
    final relationshipId = 'sib_${character.id}_${sibling.id}';

    sibling.relationships.add(Relationship(
      id: relationshipId,
      characterId: sibling.id,
      targetId: character.id,
      type: RelationshipType.sibling,
      strength: 0.7,
      status: RelationshipStatus.excellent,
    ));

    character.relationships.add(Relationship(
      id: relationshipId,
      characterId: character.id,
      targetId: sibling.id,
      type: RelationshipType.sibling,
      strength: 0.7,
      status: RelationshipStatus.excellent,
    ));

    return sibling;
  }

  static Character _generateCousin(Character uncle) {
    final cousin = generatePNJ();
    final relationshipId = 'cous_${uncle.id}_${cousin.id}';

    cousin.relationships.add(Relationship(
      id: relationshipId,
      characterId: cousin.id,
      targetId: uncle.id,
      type: RelationshipType.cousin,
      strength: 0.6,
      status: RelationshipStatus.good,
    ));

    return cousin;
  }

  static void generateAlternativeFamily(Character child) {
    final guardians = <Character>[];
    final random = Random();

    if (random.nextDouble() < 0.2) {
      guardians.addAll([
        _generateAuntUncle(child),
        _generateGrandParent(child)
      ]);
    } else {
      guardians.addAll(generateComplexFamily(child));
    }

    for (var guardian in guardians) {
      final guardianRelId = 'guard_${guardian.id}_${child.id}';
      final childRelId = 'child_${child.id}_${guardian.id}';

      guardian.relationships.add(Relationship(
        id: guardianRelId,
        characterId: guardian.id,
        targetId: child.id,
        type: RelationshipType.guardian,
        strength: 0.85,
        status: RelationshipStatus.good,
      ));

      child.relationships.add(Relationship(
        id: childRelId,
        characterId: child.id,
        targetId: guardian.id,
        type: RelationshipType.child,
        strength: 0.85,
        status: RelationshipStatus.good,
      ));
    }
  }

  static Character _generateAuntUncle(Character child) {
    final auntUncle = generatePNJ();
    final relationshipId = 'rel_${auntUncle.id}_${child.id}';

    auntUncle.relationships.add(Relationship(
        id: relationshipId,
        characterId: auntUncle.id,
        type: RelationshipType.guardian,
        targetId: child.id,
        strength: 0.75
    ));
    return auntUncle;
  }
}

Map<String, double> _generateContextualStats(Character mainChar) {
  final random = Random();
  return {
    'health': (mainChar.stats['health']! * random.nextDouble()).clamp(30.0, 100.0),
    'happiness': (mainChar.stats['happiness']! * 0.8 + random.nextDouble() * 20).clamp(0.0, 100.0),
    'intelligence': (mainChar.stats['intelligence']! * 0.9 + random.nextDouble() * 10).clamp(0.0, 100.0),
    'appearance': (mainChar.stats['appearance']! * 0.85 + random.nextDouble() * 15).clamp(0.0, 100.0),
  };
}


class PNJGenerator {
  static Character generateFromContext(Character mainChar, String city) {
    final baseAge = mainChar.age + Random().nextInt(10) - 5;
    final birthdate = DateTime.now().subtract(Duration(days: baseAge * 365));

    return Character(
      fullName: DataService.getRandomName(Random().nextBool() ? 'Homme' : 'Femme'),
      gender: Random().nextBool() ? 'Homme' : 'Femme',
      country: mainChar.country,
      city: city,
      age: baseAge.clamp(0, 100),
      birthdate: DateTime.now().subtract(Duration(days: baseAge * 365)),
      zodiacSign: DataService.calculateZodiacSign(birthdate), // Ajouté
      stats: _generateContextualStats(mainChar),
      isPNJ: true,
    );
  }
}


