import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const BitLifeApp());
}

class BitLifeApp extends StatelessWidget {
  const BitLifeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitLife Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartScreen(savedCharacters: []),
      debugShowCheckedModeBanner: false,
    );
  }
}
