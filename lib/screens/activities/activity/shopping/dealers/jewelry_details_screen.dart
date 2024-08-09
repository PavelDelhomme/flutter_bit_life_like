import 'package:flutter/material.dart';
import '../../../../../../Classes/objects/jewelry.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/bank/bank_account.dart';

class JewelryDetailsScreen extends StatelessWidget {
  final Jewelry jewelry;
  final Person person;
  final TransactionService transactionService;

  JewelryDetailsScreen({
    required this.jewelry,
    required this.person,
    required this.transactionService,
  });

  void _purchaseJewelry(BuildContext context) {
    // Logic to handle jewelry purchase
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Jewelry'),
        content: Text('Do you want to purchase ${jewelry.name} for \$${jewelry.value.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _selectAccountAndPurchase(context);
            },
            child: Text('Purchase'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _selectAccountAndPurchase(BuildContext context) {
    // Display the accounts and let the user select one
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _attemptPurchase(context, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, BankAccount account) {
    transactionService.attemptPurchase(
      account,
      jewelry,
      onSuccess: () {
        print("Purchase successful!");
        Navigator.pop(context); // Close the modal
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Purchase Successful"),
              content: Text("You have successfully purchased the ${jewelry.name}."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
      onFailure: (String message) {
        print("Failed to purchase.");
        Navigator.pop(context); // Close the modal
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jewelry.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Brand: ${jewelry.brand}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Carat: ${jewelry.carat}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Rarity: ${jewelry.rarity}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Value: \$${jewelry.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, color: Colors.green)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _purchaseJewelry(context),
              child: Text("Purchase"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
