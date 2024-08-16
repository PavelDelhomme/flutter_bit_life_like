import 'package:bit_life_like/Classes/ficalite/tax_declaration.dart';
import 'package:bit_life_like/Classes/ficalite/tax_system.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';

class TaxDeclarationScreen extends StatefulWidget {
  final Person person;

  TaxDeclarationScreen({required this.person});

  @override
  _TaxDeclarationScreenState createState() => _TaxDeclarationScreenState();
}

class _TaxDeclarationScreenState extends State<TaxDeclarationScreen> {
  double reportedIncome = 0.0;
  double deductions = 0.0;
  double charityDonations = 0.0;
  double educationExpenses = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Tax Declaration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Reported Income"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                reportedIncome = double.tryParse(value) ?? 0.0;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Deductions"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                deductions = double.tryParse(value) ?? 0.0;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Charity Donations"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                charityDonations = double.tryParse(value) ?? 0.0;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Education Expenses"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                educationExpenses = double.tryParse(value) ?? 0.0;
              },
            ),
            ElevatedButton(
              onPressed: () {
                _calculateTaxes();
              },
              child: Text("Calculate Taxes"),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateTaxes() {
    TaxSystem taxSystem = TaxSystem();
    TaxDeclaration taxDeclaration = TaxDeclaration(
      person: widget.person,
      taxSystem: taxSystem,
      reportedIncome: reportedIncome,
      reportedDeductions: deductions,
      reportedCharityDonations: charityDonations,
      reportedEucationExpenses: educationExpenses,
    );

    taxDeclaration.calculateTaxes();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tax Summary"),
          content: Text("Total taxes owed: \$${taxDeclaration.totalTaxesOwed.toStringAsFixed(2)}"),
          actions: [
            ElevatedButton(
              onPressed: () {
                taxDeclaration.fileDeclaration();
                Navigator.pop(context);
              },
              child: Text("File Declaration"),
            ),
          ],
        );
      },
    );
  }
}