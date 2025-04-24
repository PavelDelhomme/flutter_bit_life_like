import 'package:flutter/material.dart';

class CraftingScreen extends StatelessWidget {
  const CraftingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atelier de Crafting")),
      body: const Center(
        child: Text("Bienvenue dans l'atelier de crafting !"),
      ),
    );
  }
}
