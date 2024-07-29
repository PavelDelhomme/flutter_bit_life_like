import 'dart:math';

import 'person.dart';

class Decisionservice {
  void makeDecision(Person person, String decision) {
    switch (decision) {
      case "start_business":
        if (person.bankAccount >= 10000) {
          person.bankAccount -= 10000;
          // Logique pour démarrer un business
          print("${person.name} à débuté un projet d'entreprise !");
        } else {
          print("Pas assez de fond pour démarrer une entreprise...");
          print("Voulez-vous demander un pret à la banque ?");
          print("Voulez-vous faire une leveez de fonds ?");
        }
        break;
      case 'commit_crime':
        // Logic for committing crime
        // Appliquer différent type de crime
        // 1. Braqquager dze bank (faire partificiper l'utilisateur à la préparation du braquage et sa réalisation et sont évasion avec des pourcentage de réussite
        // 2. Détourner des fonds du travail (si l'utilisateur travzaile ou s'il possède une entreprise ou alors qu'il est agent dans une banque pou alors d'présidente et tout)
        bool caught = Random().nextBool();
        if (caught) {
          person.bankAccount -= 5000;
          // Implémenter la logique pour se défendre devant la justice et selectionner une pannoplie de avocat, soit commis d'office si pas d'argent sinon
          // pouvoir choisir différent cabinet d'avocat qui auront une réputation et surtout un prix
          // Implémenter la logique de comment se défendre lorsque l'ont pqssse )à la barre
          // Implementer le système de justice en fonction du pays
        } else {
          // Si je n'ai pas été prix alors choisir des montant en fonction du type de criume
        }
        break;
    }
  }

}