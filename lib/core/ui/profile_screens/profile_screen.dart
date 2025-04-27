import 'package:flutter/material.dart';
import '../../models/character.dart';
import '../banking_screens/account_selection_dialog.dart';
import '../skills_screens/skill_tree_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Character character;

  const ProfileScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Nom : ${character.fullName}', style: const TextStyle(fontSize: 18)),
          Text('Âge : ${character.age} ans', style: const TextStyle(fontSize: 18)),
          Text('Statut : ${character.currentTitle}', style: const TextStyle(fontSize: 18)),
          Text('Argent : ${character.money.toStringAsFixed(0)} \$', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            title: const Text("Voir mes compétences"),
            leading: const Icon(Icons.psychology),
            onTap: () {
              if (character.unlockedSkillTree != null) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => SkillTreeScreen(skillTree: character.unlockedSkillTree!)
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Aucun arbre de compétences débloqué.")),
                );
              }
            },
          ),
          const Divider(),
          const Text('Comptes bancaires :', style: TextStyle(fontSize: 18)),
          ...character.bankAccounts.map((account) => ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(account.bankName),
            subtitle: Text('${account.accountType.name} • ${account.balance.toStringAsFixed(2)} \$'),
          )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO ouvrir un nouvel écran pour créer un compte
            },
            child: const Text("Ouvrir un nouveau compte bancaire"),
          )
        ],
      ),
    );
  }
}
