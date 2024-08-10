import 'package:flutter/material.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../Classes/objects/antique.dart';
import 'some_antique_detail_screen.dart';

class MyAntiquesScreen extends StatelessWidget {
  final Person person;

  MyAntiquesScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Antiques'),
      ),
      body: ListView.builder(
        itemCount: person.antiques.length,
        itemBuilder: (context, index) {
          Antique antique = person.antiques[index];
          return ListTile(
            title: Text(antique.name),
            subtitle: Text('Value: \$${antique.value.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SomeAntiqueDetailScreen(antique: antique),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
