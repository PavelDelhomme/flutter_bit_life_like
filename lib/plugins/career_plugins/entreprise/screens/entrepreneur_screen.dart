import 'package:flutter/material.dart';

import '../../../../core/models/character.dart';


class EntrepreneurScreen extends StatelessWidget {
  final Character character;

  const EntrepreneurScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une entreprise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Nom de l'entreprise :", style: TextStyle(fontSize: 16)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Ex: Delhomme Industries",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  // Tu pourras appeler BusinessService.createCompany ici plus tard !
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Entreprise "$name" créée !')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Créer"),
            )
          ],
        ),
      ),
    );
  }
}
