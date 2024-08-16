import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:flutter/material.dart';

import '../../../Classes/ficalite/evasion_fiscale.dart';
import 'loan_application_screen.dart';

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
            if (account is OffshoreAccount) ...[
              SizedBox(height: 8),
              Text("Tax Haven Country: ${(account as OffshoreAccount).taxHavenCountry}", style: TextStyle(fontSize: 16)),
            ],
            SizedBox(height: 20),
            Text("Loans:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...account.loans.map((loan) => Text("Loan Amount: \$${loan.amount}, Term: ${loan.termYears} years, Rate: ${loan.interestRate}%")),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Close Account"),
              onPressed: () {
                account.closeAccount();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            ElevatedButton(
              onPressed: () => navigateToLoanApplication(context, account),
              child: Text('Apply for a Loan'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToLoanApplication(BuildContext context, BankAccount account) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoanApplicationScreen(account: account)));
  }
}
