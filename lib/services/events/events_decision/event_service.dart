import 'dart:math';
import '../../../models/person/character.dart';
import '../../../models/event.dart';

class EventService {
  final Random _random = Random();
  
  // Génère un événement aléatoire unique pour un personnage
  Event? generateRandomEvent(Character character) {
    // Liste d'événements possibles selon l'âge
    List<String> possibleEvents = _getPossibleEvents(character);
    
    if (possibleEvents.isEmpty) return null;
    
    // Sélectionner un événement aléatoire
    String description = possibleEvents[_random.nextInt(possibleEvents.length)];
    
    // Créer et retourner l'événement
    return Event(
      age: character.age,
      description: description,
      timestamp: DateTime.now(),
    );
  }
  
  // Génère plusieurs événements aléatoires
  List<Event> generateRandomEvents(Character character) {
    List<Event> events = [];
    
    // Générer entre 0 et 3 événements aléatoires
    int eventCount = _random.nextInt(3);
    
    for (int i = 0; i < eventCount; i++) {
      Event? event = generateRandomEvent(character);
      if (event != null) {
        events.add(event);
      }
    }
    
    return events;
  }
  
  // Génère des événements spécifiques à l'âge
  List<Event> generateAgeEvents(Character character) {
    List<Event> events = [];
    
    // Événements liés aux étapes importantes de la vie
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
    } else if (character.age == 20 && character.country == 'Viêt Nam') {
      events.add(Event(
        age: character.age,
        description: "J'ai participé à une fête traditionnelle à ${character.city}.",
        timestamp: DateTime.now(),
      ));
    }
    
    // Ajout d'événements aléatoires supplémentaires
    List<Event> randomEvents = generateRandomEvents(character);
    events.addAll(randomEvents);
    
    return events;
  }
  
  // Liste d'événements possibles en fonction de l'âge et d'autres critères
  List<String> _getPossibleEvents(Character character) {
    List<String> events = [];
    
    // Événements pour les nourrissons (0-2 ans)
    if (character.age <= 2) {
      events.addAll([
        "J'ai fait mes premiers pas.",
        "J'ai joué avec un jouet coloré.",
        "Je me suis endormi${character.gender == 'Femme' ? 'e' : ''} dans les bras de ma mère.",
        "J'ai goûté à de la nourriture solide pour la première fois.",
        "J'ai eu un nouveau jouet.",
      ]);
    }
    
    // Événements pour les enfants (3-12 ans)
    else if (character.age <= 12) {
      events.addAll([
        "J'ai joué dans le parc avec d'autres enfants.",
        "J'ai appris à faire du vélo.",
        "J'ai eu une bonne note à l'école.",
        "J'ai regardé un dessin animé qui m'a beaucoup plu.",
        "J'ai perdu une dent de lait.",
        "J'ai reçu un cadeau surprise.",
        "J'ai eu un petit accident à l'école.",
        "J'ai été grondé${character.gender == 'Femme' ? 'e' : ''} par mes parents.",
      ]);
    }
    
    // Événements pour les adolescents (13-17 ans)
    else if (character.age <= 17) {
      events.addAll([
        "J'ai eu mon premier coup de cœur.",
        "J'ai passé du temps avec mes amis après l'école.",
        "J'ai assisté à une fête d'anniversaire.",
        "J'ai eu une dispute avec mes parents.",
        "J'ai réussi un examen important.",
        "J'ai commencé à m'intéresser à un nouveau hobby.",
        "J'ai été puni${character.gender == 'Femme' ? 'e' : ''} pour être rentré${character.gender == 'Femme' ? 'e' : ''} tard.",
        "J'ai découvert un nouvel artiste musical que j'adore.",
      ]);
    }
    
    // Événements pour les jeunes adultes (18-29 ans)
    else if (character.age <= 29) {
      events.addAll([
        "J'ai passé une soirée mémorable avec des amis.",
        "J'ai postulé pour un emploi.",
        "J'ai déménagé dans un nouvel appartement.",
        "J'ai rencontré quelqu'un d'intéressant.",
        "J'ai voyagé dans une ville voisine.",
        "J'ai acheté un nouvel appareil électronique.",
        "J'ai essayé un nouveau restaurant.",
        "J'ai pris une décision importante concernant mon avenir.",
      ]);
    }
    
    // Événements pour les adultes (30-59 ans)
    else if (character.age <= 59) {
      events.addAll([
        "J'ai reçu une augmentation au travail.",
        "J'ai organisé un dîner chez moi.",
        "J'ai consulté un médecin pour un bilan de santé.",
        "J'ai renoué avec un${character.gender == 'Femme' ? 'e' : ''} vieil${character.gender == 'Femme' ? 'le' : ''} ami${character.gender == 'Femme' ? 'e' : ''}.",
        "J'ai fait un don à une association caritative.",
        "J'ai changé de coiffure.",
        "J'ai assisté à une réunion de famille.",
        "J'ai eu une discussion importante avec mon patron.",
      ]);
    }
    
    // Événements pour les seniors (60+ ans)
    else {
      events.addAll([
        "J'ai relu d'anciens albums photos.",
        "J'ai partagé des histoires de ma jeunesse.",
        "J'ai pris soin de mon jardin.",
        "J'ai passé du temps avec mes petits-enfants.",
        "J'ai consulté mon médecin pour un contrôle de routine.",
        "J'ai retrouvé un${character.gender == 'Femme' ? 'e' : ''} ami${character.gender == 'Femme' ? 'e' : ''} que je n'avais pas vu${character.gender == 'Femme' ? 'e' : ''} depuis longtemps.",
        "J'ai assisté à une réunion communautaire.",
        "J'ai profité d'une journée tranquille à la maison.",
      ]);
    }
    
    // Événements spécifiques au pays
    if (character.country == 'Viêt Nam') {
      events.addAll([
        "J'ai participé à la fête du Têt.",
        "J'ai mangé un délicieux phở dans un restaurant local.",
        "J'ai visité un temple bouddhiste.",
        "J'ai assisté à un spectacle de marionnettes sur l'eau.",
      ]);
    } else if (character.country == 'France') {
      events.addAll([
        "J'ai dégusté une baguette fraîche à la boulangerie.",
        "J'ai pris un café en terrasse.",
        "J'ai assisté à un festival local.",
        "J'ai visité un musée.",
      ]);
    }
    
    return events;
  }
}
