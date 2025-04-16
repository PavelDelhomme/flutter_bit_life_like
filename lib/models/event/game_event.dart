
class GameEvent {
  final String id;
  final String title;
  final String description;
  final int triggerYear;
  final bool recurring;
  final String? type;
  final String? characterId;
  final Function? onTrigger;

  GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.triggerYear,
    this.recurring = false,
    this.type,
    this.characterId,
    this.onTrigger,
  });

  bool shouldTriggerAtYear(int year) => year == triggerYear || (recurring && year >= triggerYear);

  void trigger() {
    if (onTrigger != null) {
      onTrigger!();
    }
    print("Evenement déclanché : $title");
  }
}