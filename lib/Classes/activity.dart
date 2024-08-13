enum ActivityType {
  SpendTime,     // Passer du temps ensemble
  GiftGiving,    // Offrir un cadeau
  Conflict,      // Avoir un conflit
  MurderAttempt, // Tentative de meurtre
  Celebration,   // Fête ou célébration
  Travel,        // Voyager ensemble
  SocialMediaInteraction, // Interaction sur les réseaux sociaux
  DrinkAtBar,
  GoToGym,
  WaterSkiing,
  DrugDeal,
  TakeDrugs,
  WatchMovie,
  PlaySports,
  AttendConcert,
  VolunteerWork,
  ManipulationScheme,
  CreativeProject,
  LanguagePractice,
  PhilosophicalDebate,
}

class Activity {
  final String name;
  final ActivityType type;
  final double cost;
  final int relationImpact;
  final int selfImpact;
  final String skillRequired; // Compétences requise pour l'activité
  final double skillImpact; // Impact sur la compence

  Activity({
    required this.name,
    required this.type,
    this.cost = 0.0,
    this.relationImpact = 0,
    this.selfImpact = 0,
    this.skillRequired = "",
    this.skillImpact = 0.0,
  });
}