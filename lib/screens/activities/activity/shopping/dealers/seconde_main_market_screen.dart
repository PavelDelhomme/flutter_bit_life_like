import 'package:flutter/material.dart';

import '../../../../../Classes/person.dart';
import '../../../../../services/bank/transaction_service.dart';


class SecondHandMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  SecondHandMarketScreen({
    required this.person,
    required this.transactionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Hand Market'),
      ),
      body: ListView(
        children: [
          _buildCategoryTile(context, "Real Estate", person.realEstates),
          _buildCategoryTile(context, "Vehicles", person.getAllVehicles()),
          _buildCategoryTile(context, "Jewelry", person.jewelries),
          _buildCategoryTile(context, "Electronics", person.electronics),
          _buildCategoryTile(context, "Antiques", person.antiques),
          _buildCategoryTile(context, "Instruments", person.instruments),
          _buildCategoryTile(context, "Weapons", person.armes),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String category, List<dynamic> items) {
    return ListTile(
      title: Text(category),
      onTap: () {
        _showItemsForSale(context, category, items);
      },
    );
  }

  void _showItemsForSale(BuildContext context, String category, List<dynamic> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sell $category'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                var item = items[index];
                return ListTile(
                  title: Text(item.name), // Customize as needed
                  trailing: Icon(Icons.sell),
                  onTap: () {
                    _showSellDialog(context, item);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showSellDialog(BuildContext context, dynamic item) {
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
                subtitle: Text("Balance: \$${account.balance.toStringAsFixed(2)}"),
                onTap: () {
                  double salePrice = item.value; // Adjust based on depreciation or other factors
                  transactionService.sellItem(
                    person,
                    item,
                    account,
                    salePrice,
                        () {
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item.toString()} sold for \$${salePrice.toStringAsFixed(2)}")),
                      );
                    },
                        (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to sell ${item.toString()}: $error")),
                      );
                    },
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
