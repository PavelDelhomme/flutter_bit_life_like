import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/antique/antique.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../Classes/objects/antique.dart';
import '../../../../../../Classes/life_history_event.dart';
import '../../../../../../services/life_history.dart';

class AntiqueMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;
  final AntiqueService antiqueService = AntiqueService();

  AntiqueMarketScreen({required this.person, required this.transactionService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Antique Market')),
      body: FutureBuilder<List<Antique>>(
        future: antiqueService.loadAntiques(), // Load antiques from the JSON file
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text('No antiques available.'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Antique antique = snapshot.data![index];
                return ListTile(
                  title: Text(antique.name),
                  subtitle: Text(
                      'Price: \$${antique.value.toStringAsFixed(2)}\nRarity: ${antique.rarity}\nEpoch: ${antique.epoch}'
                  ),
                  onTap: () => _purchaseAntique(context, antique),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _purchaseAntique(BuildContext context, Antique antique) {
    _selectAccountAndPurchase(context, antique);
  }

  void _selectAccountAndPurchase(BuildContext context, Antique antique) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _showPurchaseDialog(context, antique, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, Antique antique, BankAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Buy Antique"),
          content: Text(
              "Do you want to buy ${antique.name} for \$${antique.value.toStringAsFixed(2)}?"
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Pay Cash"),
              onPressed: () {
                Navigator.of(context).pop();
                _attemptPurchase(account, antique, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _attemptPurchase(BankAccount account, Antique antique, BuildContext context) {
    transactionService.attemptPurchase(
      account,
      antique,
      onSuccess: () async {
        person.antiques.add(antique); // Ajouter l'antiquité à la collection de la personne
        Navigator.pop(context, 'You bought ${antique.name} for \$${antique.value.toStringAsFixed(2)}');
        log("You bought ${antique.name} for \$${antique.value.toStringAsFixed(2)}");
        _showSuccessDialog(context);

        // Ajout à l'historique de la vie
        final event = LifeHistoryEvent(
          description: "${person.name} purchased the antique ${antique.name} for \$${antique.value.toStringAsFixed(2)}.",
          timestamp: DateTime.now(),
          ageAtEvent: person.age,
          personId: person.id,
        );
        await LifeHistoryService().saveEvent(event);
      },
      onFailure: (String message) {
        _showErrorDialog(context, message);
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Successful"),
          content: Text("Congratulations! You have successfully purchased the antique."),
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
}
