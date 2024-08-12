class Event {
  String name;
  String description;
  Map<String, dynamic> effects; // Effects on the person
  double probability; // Probability of occurrence
  Map<String, Map<String, dynamic>>? choices;

  Event({
    required this.name,
    required this.description,
    required this.effects,
    required this.probability,
    this.choices,
  });
}
