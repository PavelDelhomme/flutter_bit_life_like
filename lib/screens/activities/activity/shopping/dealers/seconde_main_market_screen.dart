import 'package:flutter/material.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../Classes/objects/antique.dart';
import '../../../../../services/bank/bank_account.dart';

class SecondHandMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  SecondHandMarketScreen({required this.person, required this.transactionService});

  // Simulated function to load antiques
  Future<List<Antique>> loadAntiques() async {
    // Assume you have a JSON or API to fetch antiques
    // For demonstration, we'll create a dummy list
    List<Antique> antiques = [
      Antique(name: 'Victorian Lamp', age: 100, dates: '1900s', artiste: 'Unknown', value: 1500),
      Antique(name: 'Old Clock', age: 200, dates: '1800s', artiste: 'Unknown', value: 2000),
    ];
    return Future.value(antiques);
  }

  void _purchaseAntique(BuildContext context, Antique antique) {
    // Logic to handle antique purchase
    // Show purchase dialog or options as per your logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Antique'),
        content: Text('Do you want to purchase ${antique.name} for \$${antique.value}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _selectAccountAndPurchase(context, antique);
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

  void _selectAccountAndPurchase(BuildContext context, Antique antique) {
    // Display the accounts and let the user select one
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _attemptPurchase(context, antique, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, Antique antique, BankAccount account) {
    transactionService.attemptPurchase(
      account,
      antique,
      onSuccess: () {
        print("Purchase successful!");
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
        title: Text('Second Hand Market'),
      ),
      body: FutureBuilder<List<Antique>>(
        future: loadAntiques(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading antiques"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No antiques available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Antique antique = snapshot.data![index];
                return ListTile(
                  title: Text(antique.name),
                  subtitle: Text('Price: \$${antique.value}'),
                  onTap: () => _purchaseAntique(context, antique),
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
