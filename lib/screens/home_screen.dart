import 'package:flutter/material.dart';

import 'marketplace_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MarketplaceMenuScreen()),
            );
          },
          child: Text('Go to Marketplace'),
        ),
      ),
    );
  }
}
