import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';

class PersonalTaxScreen extends StatelessWidget {
  final Person person;

  PersonalTaxScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    double income = person.calculateAnnualIncome();
    double taxes = person.calculateTaxes();

    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Tax Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Annual Income"),
              subtitle: Text("\$${income.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("Taxes Owed"),
              subtitle: Text("\$${taxes.toStringAsFixed(2)}"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle filing taxes
                print("Taxes filed successfully");
              },
              child: Text("File Tax Return"),
            ),
          ],
        ),
      ),
    );
  }
}
