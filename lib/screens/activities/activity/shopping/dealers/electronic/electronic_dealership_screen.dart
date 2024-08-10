import 'package:flutter/material.dart';
import '../../../../../../../Classes/person.dart';
import '../../../../../../../services/bank/transaction_service.dart';
import '../../../../../../../Classes/objects/electronic.dart';
import '../../../../../../../services/electronic/electronic.dart';
import '../../../../../../services/bank/bank_account.dart';

class ElectronicMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;
  final ElectronicService electronicService = ElectronicService();

  ElectronicMarketScreen({required this.person, required this.transactionService});

  Future<List<Electronic>> loadElectronics() async {
    await electronicService.loadAllElectronics();
    return electronicService.getAllElectronics();
  }

  void _purchaseElectronic(BuildContext buildContext, Electronic electronic) {
    // Show a dialog to confirm purchase
    showDialog(
      context: buildContext,
      builder: (context) => AlertDialog(
        title: Text('Purchase Electronic'),
        content: Text('Do you want to purchase ${electronic.model} for \$${electronic.value.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _selectAccountAndPurchase(buildContext, electronic); // Proceed to account selection
            },
            child: Text('Purchase'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel the purchase
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _selectAccountAndPurchase(BuildContext buildContext, Electronic electronic) {
    // Show a bottom sheet for account selection
    showModalBottomSheet(
      context: buildContext,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(bc); // Close the bottom sheet
                _attemptPurchase(buildContext, electronic, account); // Attempt to purchase
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext buildContext, Electronic electronic, BankAccount account) {
    transactionService.attemptPurchase(
      account,
      electronic,
      onSuccess: () {
        person.addElectronic(electronic); // Add the electronic to the person's collection
        print("Purchase successful!");

        // Use buildContext to show a success dialog
        showDialog(
          context: buildContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Purchase Successful"),
              content: Text("You have successfully purchased the ${electronic.model}."),
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

        // Use buildContext to show an error dialog
        showDialog(
          context: buildContext,
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
        title: Text('Electronics Market'),
      ),
      body: FutureBuilder<List<Electronic>>(
        future: loadElectronics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading electronics"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No electronics available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Electronic electronic = snapshot.data![index];
                return ListTile(
                  title: Text(electronic.model),
                  subtitle: Text('Price: \$${electronic.value.toStringAsFixed(2)}'),
                  onTap: () => _purchaseElectronic(context, electronic), // Pass the context from build method
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
