import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:flutter/material.dart';

import 'account_details_screen.dart';


class BankAccountScreen extends StatelessWidget {
  final Person person;

  BankAccountScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Accounts"),
      ),
      body: ListView.builder(
        itemCount: person.bankAccounts.length,
        itemBuilder: (context, index) {
          BankAccount account = person.bankAccounts[index];
          return ListTile(
            title: Text('${account.bankName} - ${account.accountType}'),
            subtitle: Text("Balance: \$${account.balance.toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountDetailsScreen(account: account),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to open a new account
        },
        child: Icon(Icons.add),
        tooltip: 'Open New Account',
      ),
    );
  }
}