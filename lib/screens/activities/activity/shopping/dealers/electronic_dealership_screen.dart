import 'package:flutter/material.dart';
import '../../../../../Classes/objects/electronic.dart';
import '../../../../../Classes/person.dart';
import '../../../../../services/bank/bank_account.dart';
import '../../../../../services/bank/transaction_service.dart';

class ElectronicsDetailsScreen extends StatelessWidget {
  final Electronic electronic;
  final Person person;
  final TransactionService transactionService;

  ElectronicsDetailsScreen({
    required this.electronic,
    required this.person,
    required this.transactionService,
  });

  void _purchaseElectronic(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Options"),
          content: Text("Choose your payment method for ${electronic.model}."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _selectAccountAndPurchase(context, electronic, false);
              },
              child: Text("Pay Cash"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _selectAccountAndPurchase(context, electronic, true);
              },
              child: Text("Apply For Loan"),
            ),
          ],
        );
      },
    );
  }

  void _selectAccountAndPurchase(BuildContext context, Electronic electronic, bool useLoan) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((BankAccount account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _attemptPurchase(context, electronic, account, useLoan),
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, Electronic electronic, BankAccount account, bool useLoan) {
    transactionService.attemptPurchase(
      account,
      electronic,
      useLoan: useLoan,
      loanTerm: 1, // Example loan term
      loanInterestRate: 3.0, // Example interest rate
      onSuccess: () {
        print("Purchase successful!");
        _showSuccessDialog(context, "You have successfully purchased the ${electronic.model}.");
      },
      onFailure: (String message) {
        print("Failed to purchase.");
        _showErrorDialog(context, message);
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Successful"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${electronic.brand} ${electronic.model}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Type: ${electronic.type}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Brand: ${electronic.brand}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Model: ${electronic.model}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Value: \$${electronic.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, color: Colors.green)),
            SizedBox(height: 20),
            if (electronic.supportsApplications)
              Text("Supports Applications: Yes", style: TextStyle(fontSize: 16, color: Colors.green)),
            if (!electronic.supportsApplications)
              Text("Supports Applications: No", style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _purchaseElectronic(context),
              child: Text("Purchase"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
