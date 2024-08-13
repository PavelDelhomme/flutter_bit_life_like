import 'package:flutter/material.dart';
import '../../../../../../../Classes/objects/antique.dart';  // Remplacez `jewelry` par `antique`
import '../../../../../../../Classes/person.dart';
import '../../../../../../../services/bank/transaction_service.dart';
import '../../../../../../../services/bank/bank_account.dart';

class AntiqueDetailsScreen extends StatelessWidget {
  final Antique antique;
  final Person person;
  final TransactionService transactionService;

  AntiqueDetailsScreen({
    required this.antique,
    required this.person,
    required this.transactionService,
  });

  void _purchaseAntique(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Antique'),
        content: Text('Do you want to purchase ${antique.name} for \$${antique.value.toStringAsFixed(2)}?'),
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
      antique,
      onSuccess: () {
        person.addAntique(antique);  // Ajoutez l'antiquité à la collection de la personne
        print("Purchase successful!");
        Navigator.pop(context); // Close the modal
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Purchase Successful"),
              content: Text("You have successfully purchased the ${antique.name}."),
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
        title: Text(antique.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Epoch: ${antique.epoch}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Rarity: ${antique.rarity}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Value: \$${antique.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, color: Colors.green)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _purchaseAntique(context),
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
