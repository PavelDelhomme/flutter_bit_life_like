
import 'package:flutter/material.dart';

import '../classes/business.dart';
class CorporateTaxScreen extends StatelessWidget {
  final Business business;

  CorporateTaxScreen({required this.business});

  @override
  Widget build(BuildContext context) {
    double annualProfit = business.calculateAnnualProfit();
    double taxesOwed = business.calculateBusinessTaxes();

    return Scaffold(
      appBar: AppBar(
        title: Text("Corporate Tax Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Annual Profit"),
              subtitle: Text("\$${annualProfit.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("Taxes Owed"),
              subtitle: Text("\$${taxesOwed.toStringAsFixed(2)}"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle filing corporate taxes
                print("Corporate Taxes filed successfully");
              },
              child: Text("File Corporate Tax Return"),
            ),
          ],
        ),
      ),
    );
  }
}
