import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping SCreen'),
      ),
      body: Center(
        child: Text('Liste des différent market d\'achat : acaht de voiture, bateau, avion, immobilier et otu et tout'),
      ),
    );
  }
}
