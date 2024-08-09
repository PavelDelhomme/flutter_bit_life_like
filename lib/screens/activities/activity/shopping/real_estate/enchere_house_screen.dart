import 'package:flutter/material.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../Classes/objects/art.dart';
import '../../../../../services/bank/bank_account.dart';

class EnchereHouseScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  EnchereHouseScreen({required this.person, required this.transactionService});

  // Simulated function to load art pieces
  Future<List<Art>> loadArtPieces() async {
    // Assume you have a JSON or API to fetch art pieces
    // For demonstration, we'll create a dummy list
    List<Art> artPieces = [
      Art(name: 'Mona Lisa', value: 1000000.0, rarity: 'Unique', epoch: 'Renaissance', dateOfCreation: '1503', artist: 'Leonardo da Vinci', type: 'Painting'),
      Art(name: 'Starry Night', value: 2000000.0, rarity: 'Unique', epoch: 'Post-Impressionism', dateOfCreation: '1889', artist: 'Vincent van Gogh', type: 'Painting'),
    ];
    return Future.value(artPieces);
  }

  void _purchaseArt(BuildContext context, Art art) {
    // Logic to handle art purchase
    // Show purchase dialog or options as per your logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Art'),
        content: Text('Do you want to purchase ${art.name} for \$${art.value.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _selectAccountAndPurchase(context, art);
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

  void _selectAccountAndPurchase(BuildContext context, Art art) {
    // Display the accounts and let the user select one
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _attemptPurchase(context, art, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, Art art, BankAccount account) {
    transactionService.attemptPurchase(
      account,
      art,
      onSuccess: () {
        print("Purchase successful!");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Purchase Successful"),
              content: Text("You have successfully purchased the ${art.name}."),
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
        title: Text('Auction House'),
      ),
      body: FutureBuilder<List<Art>>(
        future: loadArtPieces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading art pieces"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No art pieces available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Art art = snapshot.data![index];
                return ListTile(
                  title: Text(art.name),
                  subtitle: Text('Price: \$${art.value.toStringAsFixed(2)}'),
                  onTap: () => _purchaseArt(context, art),
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
