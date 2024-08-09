import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:flutter/material.dart';

import '../../../services/bank/open_account_screen.dart';
import 'account_details_screen.dart';

class BankAccountScreen extends StatelessWidget {
  final Person person;

  BankAccountScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    Map<String, List<BankAccount>> groupedAccounts = {};
    for (var account in person.bankAccounts) {
      groupedAccounts.putIfAbsent(account.bankName, () => []).add(account);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Accounts"),
      ),
      body: ListView.builder(
        itemCount: groupedAccounts.keys.length,
        itemBuilder: (context, index) {
          String bankName = groupedAccounts.keys.elementAt(index);
          List<BankAccount>? accounts = groupedAccounts[bankName];
          return ExpansionTile(
            title: Text(bankName),
            children: accounts!.map((account) => ListTile(
              title: Text('${account.accountType}'),
              subtitle: Text("Balance: \$${account.balance.toStringAsFixed(2)}\nInterest Rate: ${account.interestRate}%"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountDetailsScreen(account: account),
                  ),
                );
              },
            )).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OpenAccountScreen(person: person)),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Open New Account',
      ),
    );
  }
}
