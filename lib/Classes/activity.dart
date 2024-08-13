enum ActivityType {
  SpendTime,
  GiftGiving,
  Conflict,
  MurderAttempt,
  Celebration,
  BusinessDeal,
  Travel,
  SocialMediaInteraction,
  DrinkAtBar,
  GoToGym,
  WaterSkiing,
  DrugDeal,
  TakeDrugs,
  WatchMovie,
  PlaySports,
  AttendConcert,
  VolunteerWork,
  ManipulationScheme, // Nouveaux types d'activités
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
  final String skillRequired; // Compétence requise pour l'activité
  final double skillImpact; // Impact sur la compétence

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

// Définir la liste d'activités globalement ici
final List<Activity> activities = [
  Activity(name: 'Drink at Bar', type: ActivityType.DrinkAtBar, cost: 20, selfImpact: 5, relationImpact: 5),
  Activity(name: 'Go to Gym', type: ActivityType.GoToGym, cost: 10, selfImpact: 10, relationImpact: 5),
  Activity(name: 'Water Skiing', type: ActivityType.WaterSkiing, cost: 50, selfImpact: 15, relationImpact: 10),
  Activity(name: 'Drug Deal', type: ActivityType.DrugDeal, cost: 100, selfImpact: -10, relationImpact: -5),
  Activity(name: 'Take Drugs', type: ActivityType.TakeDrugs, cost: 50, selfImpact: -15, relationImpact: 5),
  Activity(name: 'Watch Movie', type: ActivityType.WatchMovie, cost: 15, selfImpact: 10, relationImpact: 5),
  Activity(name: 'Play Sports', type: ActivityType.PlaySports, cost: 0, selfImpact: 10, relationImpact: 10),
  Activity(name: 'Attend Concert', type: ActivityType.AttendConcert, cost: 50, selfImpact: 20, relationImpact: 10),
  Activity(name: 'Volunteer Work', type: ActivityType.VolunteerWork, cost: 0, selfImpact: 10, relationImpact: 5),
  Activity(name: 'Manipulation Scheme', type: ActivityType.ManipulationScheme, skillRequired: 'Manipulation', skillImpact: 0.5, selfImpact: -5),
  Activity(name: 'Creative Project', type: ActivityType.CreativeProject, skillRequired: 'Créativité', skillImpact: 1.0, selfImpact: 10),
  Activity(name: 'Language Practice', type: ActivityType.LanguagePractice, skillRequired: 'Langues', skillImpact: 0.5, selfImpact: 5),
  Activity(name: 'Philosophical Debate', type: ActivityType.PhilosophicalDebate, skillRequired: 'Philosophie', skillImpact: 0.5, relationImpact: 5),
];
