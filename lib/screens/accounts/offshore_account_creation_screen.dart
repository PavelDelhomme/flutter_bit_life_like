import 'package:bit_life_like/Classes/ficalite/evasion_fiscale.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer';

class OffshoreAccountCreationScreen extends StatefulWidget {
  final Person person;

  OffshoreAccountCreationScreen({required this.person});

  @override
  _OffshoreAccountCreationScreenState createState() => _OffshoreAccountCreationScreenState();
}

class _OffshoreAccountCreationScreenState extends State<OffshoreAccountCreationScreen> {
  double _initialDeposit = 0.0;
  String? _selectedTaxHavenCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Offshore Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("Select Tax Haven"),
              value: _selectedTaxHavenCountry,
              items: TaxHavenService.taxHavens.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTaxHavenCountry = newValue!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Initial Deposit",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _initialDeposit = double.tryParse(value) ?? 0.0;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedTaxHavenCountry != null && _initialDeposit > 0) {
                  _openOffshoreAccount();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Please select a tax haven and enter a valid deposit."),
                  ));
                }
              },
              child: Text("Open Offshore Account"),
            ),
          ],
        ),
      ),
    );
  }

  void _openOffshoreAccount() {
    const double minimumIncomeRequired = 100000;
    const double minimumNetWorthRequired = 500000;

    double annualIncome = widget.person.calculateAnnualIncome();
    double netWorth = widget.person.calculateNetWorth(excludeOffshore: false);

    if (annualIncome >= minimumIncomeRequired ||
        netWorth >= minimumNetWorthRequired) {
      OffshoreAccount newOffshoreAccount = OffshoreAccount(
        bankName: '${_selectedTaxHavenCountry!} Bank',
        accountNumber: 'OFF${Random().nextInt(1000000)}',
        balance: _initialDeposit,
        taxHavenCountry: _selectedTaxHavenCountry!,
      );
      widget.person.offshoreAccounts.add(newOffshoreAccount);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Offshore account opened successfully in $_selectedTaxHavenCountry."),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Cannot open offshore account: Minimum income or net worth requirements not met."),
      ));
    }
  }
}