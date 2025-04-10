import 'dart:math';
import '../models/event.dart';
import 'package:flutter/material.dart';
import '../models/person/character.dart';
import '../services/data_service.dart';
import 'main_game_screen.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  _CharacterCreationScreenState createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'Homme';
  String _selectedCountry = 'France';
  String _selectedCity = 'Paris';
  List<String> _cities = ['Paris', 'Lyon', 'Marseille'];
  bool _randomCharacter = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() async {
    // todo Chargement des pays depuis DataService (à implémenter)
    final countries = await DataService.getCountries();
    if (countries.isNotEmpty) {
      setState(() {
        _selectedCountry = countries.first;
        _loadCities(_selectedCountry);
      });
    }
  }

  void _loadCities(String country) async {
    // Charger les villes pour le pays sélectionné
    final cities = await DataService.getCitiesForCountry(country);
    if (cities.isNotEmpty) {
      setState(() {
        _cities = cities;
        _selectedCity = cities.first;
      });
    }
  }

  void _generateRandomCharacter() async {
    final Random random = Random();

    setState(() {
      _nameController.text = DataService.getRandomName(_selectedGender);
      _selectedCountry = DataService.getRandomCountry();
      _selectedGender = random.nextBool() ? 'Homme' : 'Femme';
      _randomCharacter = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedCity = _cities.isNotEmpty
              ? _cities[random.nextInt(_cities.length)]
              : 'Inconnu';
        });
      });
    });
  }

  
  void _createCharacter() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nom')),
      );
      return;
    }

    // Création du personnage avec des statistiques aléatoires
    final Random random = Random();
    final stats = {
      'happiness': (random.nextDouble() * 70 + 30), // Entre 30% et 100%
      'health': (random.nextDouble() * 70 + 30),
      'intelligence': (random.nextDouble() * 70 + 30),
      'appearance': (random.nextDouble() * 70 + 30),
    };

    // Création du personnage
    final character = Character(
      fullName: name,
      gender: _selectedGender,
      country: _selectedCountry,
      city: _selectedCity,
      birthdate: DateTime.now(),
      zodiacSign: DataService.calculateZodiacSign(DateTime.now()),
      stats: stats,
    );

    // Création des événements initiaux
    character.lifeEvents.add(
      Event(
        age: 0,
        description: 'Je suis né${ _selectedGender == 'Femme' ? 'e' : ''} à $_selectedCity, $_selectedCountry.',
        timestamp: DateTime.now(),
      ),
    );

    // Navigation vers l'écran principal du jeu
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainGameScreen(character: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      appBar: AppBar(
        title: const Text('Nouvelle Vie', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ pour le nom
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom et prénom',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            
            // Sélection du genre
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Genre',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: const Color(0xFFE53935),
              style: const TextStyle(color: Colors.white),
              items: ['Homme', 'Femme'].map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            
            // Sélection du pays
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: const InputDecoration(
                labelText: 'Pays',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: const Color(0xFFE53935),
              style: const TextStyle(color: Colors.white),
              items: ['France', 'États-Unis', 'Japon', 'Viêt Nam'].map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value!;
                  _loadCities(value);
                });
              },
            ),
            const SizedBox(height: 20),
            
            // Sélection de la ville
            DropdownButtonFormField<String>(
              value: _cities.contains(_selectedCity) ? _selectedCity : null,
              decoration: const InputDecoration(
                labelText: 'Ville',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: const Color(0xFFE53935),
              style: const TextStyle(color: Colors.white),
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value!;
                });
              },
            ),
            
            const Spacer(),
            
            // Bouton pour personnage aléatoire
            TextButton(
              onPressed: _generateRandomCharacter,
              child: const Text(
                'Personnage aléatoire',
                style: TextStyle(color: Colors.white),
              ),
            ),
            
            // Bouton pour créer le personnage
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _createCharacter,
              child: Text(
                'Commencer la vie de ${_nameController.text.isEmpty ? "[votre nom]" : _nameController.text}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}