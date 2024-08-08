import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:flutter/material.dart';

class AccountDetailsScreen extends StatelessWidget {
  final BankAccount account;

  AccountDetailsScreen({required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Details"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Bank: ${account.bankName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Account Number: ${account.accountNumber}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Account Type: ${account.accountType}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Balance: \$${account.balance.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Close Account"),
              onPressed: () {
                account.closeAccount();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}