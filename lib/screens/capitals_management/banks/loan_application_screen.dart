import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:flutter/material.dart';

import '../../../Classes/objects/real_estate.dart';

class LoanApplicationScreen extends StatefulWidget {
  final BankAccount account;
  final RealEstate? realEstate; // Rendre RealEstate optionnel
  final String? loanDescription; // Description du prêt pour d'autres usages
  final Person person;

  LoanApplicationScreen({
    required this.account,
    this.realEstate,
    this.loanDescription,
    required this.person,
  });

  @override
  _LoanApplicationScreenState createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  double _loanAmount = 0.0;
  int _loanTerm = 10; // En années

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for a Loan"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Loan Amount',
                  suffix: Text("EUR"),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  _loanAmount = amount;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Term (years)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the term of the loan';
                  }
                  int? term = int.tryParse(value);
                  if (term == null || term <= 0) {
                    return 'Please enter a valid number of years';
                  }
                  _loanTerm = term;
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    applyForLoan();
                  }
                },
                child: Text("Submit Loan Application"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void applyForLoan() {
    if (widget.person.age < 16) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You must be at least 16 years old to apply for a loan"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    bool approved = FinancialService.instance.applyForLoan(
      widget.account,
      _loanAmount,
      _loanTerm,
      FinancialService.getInterestRate(
          widget.account.bankName, widget.account.accountType),
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          approved ? 'Loan approved!' : 'Loan denied due to credit policies.'),
      backgroundColor: approved ? Colors.green : Colors.red,
    ));

    if (approved) {
      Navigator.pop(context); // Return to the previous screen if approved.
    }
  }
}
