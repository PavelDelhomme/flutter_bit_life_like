import 'package:flutter/material.dart';
import '../../../Classes/objects/jewelry.dart';
import '../../../Classes/person.dart';
import '../../../services/bank/transaction_service.dart';
import '../../../services/jewelry/jewelry.dart';

class MyJewelryDetailsScreen extends StatelessWidget {
  final Jewelry jewelry;
  final JewelryService jewelryService;
  final Person person;
  final TransactionService transactionService;

  MyJewelryDetailsScreen({
    required this.jewelry,
    required this.jewelryService,
    required this.person,
    required this.transactionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of ${jewelry.name}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${jewelry.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Brand: ${jewelry.brand}", style: TextStyle(fontSize: 16)),
            Text("Material: ${jewelry.material}", style: TextStyle(fontSize: 16)),
            Text("Carat: ${jewelry.carat}", style: TextStyle(fontSize: 16)),
            Text("Value: \$${jewelry.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            Text("Condition: ${jewelry.condition}", style: TextStyle(fontSize: 16)),
            Text("Rare: ${jewelry.isRare ? 'Yes' : 'No'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Sell Jewelry"),
              onPressed: () {
                _showSellJewelryDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSellJewelryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Bank Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: person.bankAccounts.map((account) {
              return ListTile(
                title: Text("Account: ${account.accountNumber}"),
                subtitle: Text("Balance : \$${account.balance.toStringAsFixed(2)}"),
                onTap: () {
                  jewelryService.sellJewelry(jewelry, account, person, transactionService);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
