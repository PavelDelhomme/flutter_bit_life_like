import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:bit_life_like/services/jewelry/jewelry.dart';
import 'package:flutter/material.dart';

import '../../../../../../Classes/life_history_event.dart';
import '../../../../../../services/life_history.dart';

class JewelryMarketScreen extends StatelessWidget {
  final JewelryService jewelryService;
  final TransactionService transactionService;
  final Person person;

  JewelryMarketScreen({
    required this.jewelryService,
    required this.transactionService,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jewelry Market")),
      body: FutureBuilder<List<Jewelry>>(
        future: jewelryService.getAllJewelries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No jewelries found."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Jewelry jewelry = snapshot.data![index];
                return ListTile(
                  title: Text(jewelry.name),
                  subtitle: Text('Price: \$${jewelry.value.toStringAsFixed(2)}'),
                  onTap: () => _buyJewelry(context, jewelry),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _buyJewelry(BuildContext context, Jewelry jewelry) {
    _selectAccountAndPurchase(context, jewelry);
  }

  void _selectAccountAndPurchase(BuildContext context, Jewelry jewelry) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _showPurchaseDialog(context, jewelry, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, Jewelry jewelry, BankAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Buy Jewelry"),
          content: Text("Do you want to buy ${jewelry.name} for \$${jewelry.value.toStringAsFixed(2)}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Pay Cash"),
              onPressed: () {
                Navigator.of(context).pop();
                _attemptPurchase(account, jewelry, context);
              },
            ),
          ],
        );
      },
    );
  }
  void _attemptPurchase(BankAccount account, Jewelry jewelry, BuildContext context) {
    transactionService.attemptPurchase(
      account,
      jewelry,
      onSuccess: () async {
        print("Purchase successful!");
        person.addJewelry(jewelry);

        // Ajout à l'historique
        final event = LifeHistoryEvent(
          description: "${person.name} purchased the jewelry ${jewelry.name} for \$${jewelry.value.toStringAsFixed(2)}.",
          timestamp: DateTime.now(),
          ageAtEvent: person.age,
          personId: person.id,
        );
        await LifeHistoryService().saveEvent(event);

        _showSuccessDialog(context);
      },
      onFailure: (String message) {
        print("Failed to purchase.");
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
          content: Text("Congratulations You have successfully purchased the jewelry."),
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
