import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../Classes/objects/jewelry.dart';
import '../../../../../../services/jewelry/jewelry.dart';
import '../../../../../services/bank/bank_account.dart';

class JewelryMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;
  final JewelryService jewelryService = JewelryService();

  JewelryMarketScreen({required this.person, required this.transactionService});

  Future<List<Jewelry>> loadJewelries() async {
    await jewelryService.loadAllJewelries();
    return jewelryService.getAllJewelries();
  }

  void _purchaseJewelry(BuildContext context, Jewelry jewelry) {
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
              _selectAccountAndPurchase(context, jewelry);
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

  void _selectAccountAndPurchase(BuildContext parentContext, Jewelry jewelry) {
    // Use the parent context to ensure it's valid when showing dialogs
    showModalBottomSheet(
      context: parentContext,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _attemptPurchase(parentContext, jewelry, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext parentContext, Jewelry jewelry, BankAccount account) {
    transactionService.attemptPurchase(
      account,
      jewelry,
      onSuccess: () {
        print("Purchase successful!");
        // Use parent context here
        showDialog(
          context: parentContext,
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
        // Use parent context here
        showDialog(
          context: parentContext,
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
        title: Text('Jewelry Market'),
      ),
      body: FutureBuilder<List<Jewelry>>(
        future: loadJewelries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading jewelries"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No jewelries available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Jewelry jewelry = snapshot.data![index];
                return ListTile(
                  title: Text(jewelry.name),
                  subtitle: Text('Price: \$${jewelry.value.toStringAsFixed(2)}'),
                  onTap: () => _purchaseJewelry(context, jewelry),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
