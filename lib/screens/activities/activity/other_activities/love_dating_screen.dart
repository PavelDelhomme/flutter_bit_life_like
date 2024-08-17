import 'package:flutter/material.dart';

import '../../../../Classes/person.dart';

class LoveDatingScreen extends StatefulWidget {
  final Person person;

  LoveDatingScreen({required this.person});

  @override
  _LoveDatingScreenState createState() => _LoveDatingScreenState();
}

class _LoveDatingScreenState extends State<LoveDatingScreen> {
  List<Person> potentialPartners = []; // Liste des partenaires potentiels
  Person? selectedPartner;

  @override
  void initState() {
    super.initState();
    _loadPotentialPartners();
  }

  void _loadPotentialPartners() {
    // Simulez le chargement des partenaires potentiels (cela peut être personnalisé)
    potentialPartners = [
      Person(
        name: "Alex",
        gender: "Male",
        country: "France",
        age: 28,
        happiness: 80,
        intelligence: 90,
        health: 90,
        appearance: 70,
        // Valeur par défaut pour appearance
        karma: 100,
        // Valeur par défaut pour karma
        isImprisoned: false,
        // Valeur par défaut pour isImprisoned
        prisonTerm: 0, // Valeur par défaut pour prisonTerm
      ),
      Person(
        name: "Sophie",
        gender: "Female",
        country: "France",
        age: 26,
        happiness: 85,
        intelligence: 88,
        health: 85,
        appearance: 75,
        // Valeur par défaut pour appearance
        karma: 100,
        // Valeur par défaut pour karma
        isImprisoned: false,
        // Valeur par défaut pour isImprisoned
        prisonTerm: 0, // Valeur par défaut pour prisonTerm
      ),
      // Ajoutez d'autres personnes ici
    ];
  }

  void _startDating(Person partner) {
    setState(() {
      selectedPartner = partner;
    });
    widget.person.partners
        .add(partner); // Ajoutez cette personne comme partenaire
    partner.partners.add(widget.person); // Réciprocité de la relation

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("You started dating ${partner.name}!"),
    ));
  }

  void _endRelationship(Person partner) {
    setState(() {
      widget.person.partners.remove(partner);
      partner.partners.remove(widget.person);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You broke up with ${partner.name}."),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Love and Dating'),
      ),
      body: Column(
        children: [
          if (selectedPartner == null)
            Expanded(
              child: ListView.builder(
                itemCount: potentialPartners.length,
                itemBuilder: (context, index) {
                  final partner = potentialPartners[index];
                  return ListTile(
                    title: Text(partner.name),
                    subtitle:
                        Text('Age: ${partner.age}, Gender: ${partner.gender}'),
                    onTap: () {
                      _startDating(partner);
                    },
                  );
                },
              ),
            )
          else
            Column(
              children: [
                Text('You are dating ${selectedPartner!.name}'),
                ElevatedButton(
                  onPressed: () {
                    _endRelationship(selectedPartner!);
                  },
                  child: Text('End Relationship'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
