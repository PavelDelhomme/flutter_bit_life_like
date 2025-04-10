import '../screens/character_creation_screen.dart';
import 'package:flutter/material.dart';
import '../models/person/character.dart';
import 'main_game_screen.dart';

class StartScreen extends StatelessWidget {
  final List<Character> savedCharacters;

  const StartScreen({super.key, required this.savedCharacters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      appBar: AppBar(
        title: Image.network(
          'https://www.touchtapplay.com/wp-content/uploads/2022/09/How-to-Start-a-Successful-Business-in-Bitlife-768x403.png',
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/bitlife_logo.png');
          },
        ),
        backgroundColor: const Color(0xFFE53935),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "MES VIES",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: savedCharacters.isEmpty
              ? const Center(
                child: Text(
                  "Aucune vie en cours",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                itemCount: savedCharacters.length,
                itemBuilder: (context, index) {
                  final character = savedCharacters[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(character.fullName[0]),
                    ),
                    title: Text(
                      character.fullName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${character.age} ans - ${character.currentTitle}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainGameScreen(character: character),
                        ),
                      );
                    },
                  );
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CharacterCreationScreen(),
                  ),
                );
              },
              child: const Text(
                'NOUVELLE VIE',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}