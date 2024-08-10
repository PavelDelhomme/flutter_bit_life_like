import 'package:flutter/material.dart';
import '../../../../../../../Classes/person.dart';
import '../../../../../../../services/bank/transaction_service.dart';
import '../../../../../../../Classes/objects/electronic.dart';
import '../../../../../../services/bank/bank_account.dart';

class ElectronicMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  ElectronicMarketScreen({required this.person, required this.transactionService});

  // Simulated function to load electronics
  Future<List<Electronic>> loadElectronics() async {
    // Assume you have a JSON or API to fetch electronics
    // For demonstration, we'll create a dummy list
    List<Electronic> electronics = [
      Electronic(id: '1', type: 'Smartphone', brand: 'Apple', model: 'iPhone 13', value: 999.0, supportsApplications: true),
      Electronic(id: '2', type: 'Laptop', brand: 'Dell', model: 'XPS 13', value: 1199.0, supportsApplications: true),
    ];
    return Future.value(electronics);
  }

  void _purchaseElectronic(BuildContext context, Electronic electronic) {
    // Logic to handle electronic purchase
    // Show purchase dialog or options as per your logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Electronic'),
        content: Text('Do you want to purchase ${electronic.model} for \$${electronic.value.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _selectAccountAndPurchase(context, electronic);
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

  void _selectAccountAndPurchase(BuildContext context, Electronic electronic) {
    // Display the accounts and let the user select one
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _attemptPurchase(context, electronic, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, Electronic electronic, BankAccount account) {
    transactionService.attemptPurchase(
      account,
      electronic,
      onSuccess: () {
        print("Purchase successful!");
        showDialog(
          context: context,
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
                  onTap: () => _purchaseElectronic(context, electronic),
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
