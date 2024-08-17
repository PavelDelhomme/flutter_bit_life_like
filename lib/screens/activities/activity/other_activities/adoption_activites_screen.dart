import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../Classes/person.dart';

class AdoptionActivitesScreen extends StatefulWidget {
  final Person person;

  AdoptionActivitesScreen({required this.person});

  @override
  _AdoptionActivitesScreenState createState() => _AdoptionActivitesScreenState();
}

class _AdoptionActivitesScreenState extends State<AdoptionActivitesScreen> {
  final _formKey = GlobalKey<FormState>();
  String _childName = '';
  int _childAge = 0;
  String _childGender = 'Male';

  final List<String> randomNames = ["Liam", "Emma", "Noah", "Olivia", "Ava", "Ethan", "Sophia"];
  final Random random = Random();

  Person generateRandomChild() {
    String childName = randomNames[random.nextInt(randomNames.length)];
    String gender = random.nextBool() ? "Male" : "Female";
    int age = random.nextInt(18); // Enfants de 0 à 17 ans

    return Person(
      name: childName,
      gender: gender,
      country: widget.person.country,
      age: age,
      appearance: random.nextDouble() * 100,
      health: random.nextDouble() * 100,
      happiness: random.nextDouble() * 100,
      karma: random.nextDouble() * 100,
      intelligence: random.nextDouble() * 100,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [],
      offshoreAccounts: [],
      parents: [widget.person],
    );
  }

  void _adoptRandomChild() {
    Person randomChild = generateRandomChild();

    setState(() {
      widget.person.children.add(randomChild);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("You adopted ${randomChild.name}!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adoption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _adoptRandomChild,
              child: Text('Adopt a Random Child'),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Child Name'),
                    onSaved: (value) {
                      _childName = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Child Age'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _childAge = int.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Child Gender'),
                    value: _childGender,
                    onChanged: (newValue) {
                      setState(() {
                        _childGender = newValue!;
                      });
                    },
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _adoptChild();
                      }
                    },
                    child: Text('Adopt Custom Child'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _adoptChild() {
    Person newChild = Person(
      name: _childName,
      gender: _childGender,
      country: widget.person.country,
      age: _childAge,
      appearance: 50,
      intelligence: 50,
      health: 100,
      happiness: 100,
      karma: 100,
      isImprisoned: false,
      prisonTerm: 0,
      bankAccounts: [],
      offshoreAccounts: [],
      parents: [widget.person],
    );

    setState(() {
      widget.person.children.add(newChild);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("You adopted $_childName!"),
    ));
  }
}
