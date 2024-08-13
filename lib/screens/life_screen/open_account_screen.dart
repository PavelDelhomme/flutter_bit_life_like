import 'package:flutter/material.dart';

import '../../services/bank/bank_account.dart';

class OpenAccountScreen extends StatefulWidget {
  @override
  _OpenAccountScreenState createState() => _OpenAccountScreenState();
}

class _OpenAccountScreenState extends State<OpenAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedBank;
  String? accountType;
  double? initialDeposit;

  List<Bank> banks = []; // Supposons que vous chargiez cette liste quelque part dans votre app

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Open New Account')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: selectedBank,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBank = newValue;
                });
              },
              items: banks.map<DropdownMenuItem<String>>((Bank bank) {
                return DropdownMenuItem<String>(
                  value: bank.name,
                  child: Text(bank.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Bank',
              ),
            ),
            DropdownButtonFormField<String>(
              value: accountType,
              onChanged: (String? newValue) {
                setState(() {
                  accountType = newValue;
                });
              },
              items: ['Checking', 'Savings', 'Investment']  // Change this depending on the selected bank
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Account Type',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Initial Deposit'),
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                initialDeposit = double.tryParse(value ?? '0') ?? 0.0;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Assuming BankService is a class that handles bank operations
                  print('Opening account at $selectedBank with type $accountType and deposit $initialDeposit');
                  // You can implement your logic here
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
