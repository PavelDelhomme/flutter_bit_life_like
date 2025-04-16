import '../../../models/activity.dart';
import '../../../models/person/character.dart';

class PoliticalCampaignActivity extends Activity {
  final Character character;

  PoliticalCampaignActivity(this.character)
      : super(
    id: 'political_campaign',
    name: 'Lancer une campagne politique',
    type: ActivityType.leadership,
    skillRequirements: {'charisma': 30.0, 'intelligence': 30.0},
    skillGains: {'charisma': 10.0},
    cost: 5000,
    duration: Duration(hours: 3),
    successRate: 0.5,
    risk: 0.2,
  );

  @override
  void perform() {
    final hasWon = character.stats['intelligence']! + character.stats['charisma']! > 130;
    if (hasWon) {
      character.statuses.add("Elu");
      character.log("Vous avez été élu !");
    } else {
      character.log("Votre campagne à échoué, mais vous avez gagnez en expérience.");
      character.experience += 10;
      character.improveSkill('intelligence', 10);
    }
  }
}
