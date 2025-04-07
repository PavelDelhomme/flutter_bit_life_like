import 'dart:math';

import 'antique.dart';
import 'arme.dart';
import 'bank_account.dart';
import 'jewelry.dart';
import 'legal.dart';
import 'pet.dart';
import 'vehicle.dart';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';

import 'relationship.dart';
import 'career.dart';
import 'assets.dart';
import 'event.dart';
import 'real_estate.dart';

class Character {
  String id;
  String fullName;
  String gender;
  String country;
  String city;
  int age;
  DateTime birthdate;
  String zodiacSign;
  bool isAlive;
  DateTime? deathDate;
  String? deathCause;

  Map<String, double> stats;

  double money;
  List<BankAccount> bankAccounts;
  double creditScore;

  List<Relationship> relationships;
  List<Character> parents;
  List<Character> siblings;
  List<Character> children;
  List<Character> partners;
  List<Pet> pets;

  String currentTitle;
  Career? career;
  EducationLevel educationLevel;
  List<Skill> skills;
  List<String> diplomas;

  // Possessions
  List<Asset> assets;
  List<Vehicle> vehicles;
  List<RealEstate> properties;
  List<Jewelry> jewelries;
  List<Antique> antiques;
  List<Arme> armes;

  // Judiciaire et fiscal
  double declaredIncome;
  double actualIncome;
  bool hasCriminalRecord;
  List<Crime> criminalHistory;
  int yearsInPrison;

  // Offshore et évasion fiscale
  List<OffshoreAccount> offshoreAccounts;

  // Historique
  List<Event> lifeEvents;


  Character({
    String? id,
    required this.fullName,
    required this.gender,
    required this.country,
    required this.city,
    this.age = 0,
    required this.birthdate,
    required this.zodiacSign,
    this.isAlive = true,
    this.deathDate,
    this.deathCause,
    required this.stats,
    this.money = 0,
    List<BankAccount>? bankAccounts,
    this.creditScore = 700,
    List<Relationship>? relationships,
    List<Character>? parents,
    List<Character>? siblings,
    List<Character>? children,
    List<Character>? partners,
    List<Pet>? pets,
    this.currentTitle = "Nourrisson",
    this.career,
    this.educationLevel = EducationLevel.none,
    List<Skill>? skills,
    List<String>? diplomas,
    List<Asset>? assets,
    List<Vehicle>? vehicles,
    List<RealEstate>? properties,
    List<Jewelry>? jewelries,
    List<Antique>? antiques,
    List<Arme>? armes,
    this.declaredIncome = 0,
    this.actualIncome = 0,
    this.hasCriminalRecord = false,
    List<Crime>? criminalHistory,
    this.yearsInPrison = 0,
    List<OffshoreAccount>? offshoreAccounts,
    List<Event>? lifeEvents,
  }) :
  id = id ?? 'char_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}',
  bankAccounts = bankAccounts ?? [],
  relationships = relationships ?? [],
  parents = parents ?? [],
  siblings = siblings ?? [],
  children = children ?? [],
  partners = partners ?? [],
  pets = pets ?? [],
  skills = skills ?? [],
  diplomas = diplomas ?? [],
  assets = assets ?? [],
  vehicles = vehicles ?? [],
  properties = properties ?? [],
  jewelries = jewelries ?? [],
  antiques = antiques ?? [],
  armes = armes ?? [],
  criminalHistory = criminalHistory ?? [],
  offshoreAccounts = offshoreAccounts ?? [],
  lifeEvents = lifeEvents ?? [];

  double calculateTotalIncome() {
    double total = 0;
    if (career != null) {
      total += career!.calculateAnnualIncome();
    }

    // Revenu passif (loyers, intérêts)
    for (var property in properties) {
      if (property.isRented) {
        total += property.monthlyRent * 12;
      }
    }

    // intérpets des comptes bancaires
    for (var account in bankAccounts) {
      total += account.balance * (account.interestRate / 100);
    }

    return total;
  }

  // Ajout d'un événement de vie
  void addLifeEvent(String description) {
    lifeEvents.add(Event(
      age: age,
      description: description,
      timestamp: DateTime.now(),
    ));
  }

  // Changement vers le personnage d'un enfant (héritage)
  Character switchToChild() {
    if (children.isEmpty) {
      throw Exception("Pas d'enfants disponibles pour hériter");
    }

    // Sélectionner un enfant (par défaut le premier)
    Character heir = children.first;

    // Transfert d'héritage - appliquer taxes selon pays
    double inheritanceTax = 0.3; // 30% par défaut
    double inheritedAmount = money * (1 - inheritanceTax);
    heir.money = inheritedAmount;

    addLifeEvent("Je suis décédé(e) et mon héritage est passé à ${heir.fullName}");
    heir.addLifeEvent("J'ai hérité de \$${inheritedAmount.toStringAsFixed(2)} de ${fullName}");

    // Transfert des propriétés
    for (var properti in properties) {
      properti.transfertOwnership(this, heir);
      heir.properties.add(properti);
    }

    return heir;
  }

  void ageUp() {
    age++;
    // Déclenchement des évènement basé sur lage
  }
}