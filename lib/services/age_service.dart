// services/age_service.dart
import 'dart:math';
import '../models/work/career.dart';
import '../../services/events/events_decision/event_service.dart';

import '../models/person/character.dart';
import '../models/event.dart';
import '../../services/bank/financial_service.dart';

class AgeService {
  final EventService _eventService;
  final FinancialService _financialService;
  final Random _random = Random();
  
  AgeService(this._eventService, this._financialService);

  void ageUp(Character character) {
    // Vieillir le personnage
    character.age++;
    
    // Générer des événements selon l'âge
    List<Event> ageEvents = _eventService.generateAgeEvents(character);
    character.lifeEvents.addAll(ageEvents);
    
    // Gestion des possession
    _updateAssets(character);

    // Evolution des relations
    _updateRelationships(character);

    // Gestion financière
    _financialService.processYearlyFinances(character);

    // Mettre à jour les statistiques
    _updateStats(character);
    
    // Mettre à jour le titre actuel
    _updateTitle(character);
    
    // Vieillir les possessions
    _ageAssets(character);
   
    // Gérer les événements aléatoires potentiellement mortels
    if (_checkDeathEvents(character)) {
      return; // Personnage décédé
    }

    // Evenements aléatoires
    _handleRandomEvents(character);
  }
  

  void _updateAssets(Character character) {
    // Vieillissement et évolution des possession
    for (var asset in character.assets) {
      asset.age++;

      // Maintenance automatique si l'arget est disponible
      if (character.money >= asset.maintenanceCost && _random.nextDouble() < 0.7) {
        asset.maintain();
        character.money -= asset.maintenanceCost;
      } else {
        asset.deteriorate();
      }
    }

    // Vieillissement des véhicules
    for (var vehicle in character.vehicles) {
      vehicle.deteriorate();
    }

    // Vieillissement des propriétés
    for (var properti in character.properties) {
      properti.age++;

      // Revenus locatifs
      if (properti.isRented) {
        character.money += properti.monthlyRent * 12; // Paiement des impots on verra mais jamais automatique le personnage doit déclarer ou valider quelque chose qui se fera automatiquement et peux traffiquer ce qu'il souhaite avec pourcentage d'être pris l'année d'après et le reste de sa vie bref
      }

      // Frais de maintenance
      if (character.money >= properti.maintenanceCost) {
        properti.maintain();
        character.money -= properti.maintenanceCost;
      } else {
        properti.deteriorate();
      }
    }
  }

  List<Event> _generateAgeEvents(Character character) {
    List<Event> events = [];
    
    // Événements liés à l'âge
    if (character.age == 1) {
      events.add(Event(
        age: character.age,
        description: "J'ai dit mes premiers mots.",
        timestamp: DateTime.now(),
      ));
    } else if (character.age == 3) {
      events.add(Event(
        age: character.age,
        description: "Je commence à aller à la maternelle.",
        timestamp: DateTime.now(),
      ));
    } else if (character.age == 6) {
      events.add(Event(
        age: character.age,
        description: "Je commence l'école primaire.",
        timestamp: DateTime.now(),
      ));
    } else if (character.age == 11) {
      events.add(Event(
        age: character.age,
        description: "Je commence le collège.",
        timestamp: DateTime.now(),
      ));
    } else if (character.age == 15) {
      events.add(Event(
        age: character.age,
        description: "Je commence le lycée.",
        timestamp: DateTime.now(),
      ));
    } else if (character.age == 18) {
      events.add(Event(
        age: character.age,
        description: "Je suis maintenant majeur${character.gender == 'Femme' ? 'e' : ''}.",
        timestamp: DateTime.now(),
      ));
    }
    
    // Événements aléatoires basés sur l'âge
    List<Event> randomEvents = _eventService.generateRandomEvents(character);
    events.addAll(randomEvents);
    
    return events;
  }
  
  void _updateStats(Character character) {
    // Santé diminue légèrement avec l'âge
    if (character.age > 40) {
      double healthDecline = 0.5 + (_random.nextDouble() * 0.5);
      character.stats['health'] = (character.stats['health']! - healthDecline).clamp(0.0, 100.0);
    }
    
    // Intelligence augmente pendant l'enfance et l'adolescence
    if (character.age < 25) {
      double intelligenceGain = 0.5 + (_random.nextDouble() * 1.0);
      character.stats['intelligence'] = (character.stats['intelligence']! + intelligenceGain).clamp(0.0, 100.0);
    } else if (character.age > 75) {
      double intelligenceDecline = 0.3 + (_random.nextDouble() * 0.7);
      character.stats['intelligence'] = (character.stats['intelligence']! - intelligenceDecline).clamp(0.0, 100.0);
    }
    
    // Apparence évolue différemment selon l'âge
    if (character.age > 30) {
      double appearanceDecline = 0.2 + (_random.nextDouble() * 0.4);
      character.stats['appearance'] = (character.stats['appearance']! - appearanceDecline).clamp(0.0, 100.0);
    }
    
    // Bonheur fluctue aléatoirement
    double happinessChange = (_random.nextDouble() * 10.0) - 5.0; // -5 à +5
    character.stats['happiness'] = (character.stats['happiness']! + happinessChange).clamp(0.0, 100.0);
  }
  
  void _updateTitle(Character character) {
    if (character.age < 3) {
      character.currentTitle = "Nourrisson";
    } else if (character.age < 6) {
      character.currentTitle = "Enfant";
    } else if (character.age < 13) {
      character.currentTitle = "Écolier";
    } else if (character.age < 18) {
      character.currentTitle = "Adolescent";
    } else if (character.career != null && character.career!.status != EmploymentStatus.unemployed) {
      character.currentTitle = character.career!.jobTitle;
    } else if (character.age >= 65) {
      character.currentTitle = "Retraité";
    } else {
      character.currentTitle = "Adulte";
    }
  }
  
  void _ageAssets(Character character) {
    for (var asset in character.assets) {
      asset.age1Year();
    }
  }
  
  void _handleFinances(Character character) {
    // Calculer les revenus
    double annualIncome = 0.0;
    if (character.career != null) {
      annualIncome += character.career!.calculateAnnualIncome();
    }
    
    // Revenus passifs des propriétés
    for (var asset in character.assets) {
      annualIncome += asset.monthlyIncome * 12;
    }
    
    // Dépenses de maintenance pour les biens
    double annualExpenses = 0.0;
    for (var asset in character.assets) {
      annualExpenses += asset.maintenanceCost * 12;
      if (asset.isInsured) {
        annualExpenses += asset.insuranceCost * 12;
      }
    }
    
    // Impôts (simplifié)
    double taxAmount = annualIncome * 0.2; // 20% d'impôts
    annualExpenses += taxAmount;
    
    // Solde net
    double netAmount = annualIncome - annualExpenses;
    
    // Appliquer au compte bancaire principal
    if (character.bankAccounts.isNotEmpty) {
      character.bankAccounts.first.balance += netAmount;
    } else {
      character.money += netAmount;
    }
    
    // Ajouter un événement financier annuel
    character.lifeEvents.add(Event(
      age: character.age,
      description: "Bilan financier annuel: Revenus \$${annualIncome.toStringAsFixed(2)}, Dépenses \$${annualExpenses.toStringAsFixed(2)}",
      timestamp: DateTime.now(),
    ));
  }
  
  void _updateRelationships(Character character) {
    for (var relationship in character.relationships) {
      // Relations évoluent naturellement avec le temps
      double change = (_random.nextDouble() * 0.1) - 0.05; // -0.05 à +0.05
      if (change > 0) {
        relationship.improve(change);
      } else {
        relationship.deteriorate(-change);
      }
      
      // Incrémenter les années de connaissance
      relationship.yearsKnown++;
    }
  }
  
  bool _checkDeathEvents(Character character) {
    // Risque de mort naturelle augmente avec l'âge
    double deathRisk = 0.0;
    
    if (character.age > 70) {
      deathRisk = (character.age - 70) * 0.005;
    }
    
    // Santé influence le risque
    double healthFactor = (100 - character.stats['health']!) / 200; // 0 à 0.5
    deathRisk += healthFactor;
    
    // Vérifier si la mort survient
    if (_random.nextDouble() < deathRisk) {
      character.isAlive = false;
      character.deathDate = DateTime.now();
      character.deathCause = "Mort naturelle";
      
      character.lifeEvents.add(Event(
        age: character.age,
        description: "Je suis décédé${character.gender == 'Femme' ? 'e' : ''} de causes naturelles à l'âge de ${character.age} ans.",
        timestamp: DateTime.now(),
      ));
      return true;
    }
    return false;
  }

  void _handleRandomEvents(Character character) {
    // Change d'évènement aléatoires
    if (_random.nextDouble() < 0.7) {
      List<Event> randomEvents = _eventService.generateRandomEvents(character);
      character.lifeEvents.addAll(randomEvents);
    }
  }

  void processYearlyUpdate(Character character) async {
    // Veuillissement
    character.age++;

    // Eveeneùent financier
    _financialService.processYearlyFinances(character);

    // Vérificationlégale
    if (Random().nextDouble() < 0.2) {
      character.legalSystem?.performAnnualAudit(character);
    }

    // Sauvegarde automatique
    await character.save();
  }

  void ageUpAll(List<Character> characters) {
    for (final character in characters) {
      if (character.isAlive) {
        character.age++;
        _updateStats(character);
        _updateRelationships(character);

        if (_checkDeathEvents(character)) {
          character.isAlive = false;
          character.deathDate = DateTime.now();
          character.deathCause = "Mort naturelle";
          continue; // Ne pas continuer à traiter un personnage décédé
        }

        // Vieillissement des possessions
        _ageAssets(character);

        // Vérification légale annuelle
        if (character.legalSystem != null) {
          character.legalSystem!.performAnnualAudit(character);
        }

        // Sauvegarde automatique après mise à jour annuelle
        character.save();
      }
    }
  }


}
