import 'package:flutter/material.dart';

import '../../../Classes/objects/real_estate.dart';
import '../../../services/real_estate/real_estate.dart';
import '../../../services/bank/transaction_service.dart';
import '../../../Classes/person.dart';

class RealEstateManagementScreen extends StatelessWidget {
  final List<RealEstate> properties;
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final Person person;

  RealEstateManagementScreen({
    required this.properties,
    required this.realEstateService,
    required this.transactionService,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Estate Management'),
      ),
      body: ListView(
        children: properties.map((property) {
          return ListTile(
            title: Text(property.name),
            subtitle: Text('Condition: ${property.condition.toStringAsFixed(2)}%'),
            onTap: () {
              _manageProperty(context, property);
            },
          );
        }).toList(),
      ),
    );
  }

  void _manageProperty(BuildContext context, RealEstate property) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Property: ${property.name}"),
              Text("Value: \$${property.value.toStringAsFixed(2)}"),
              Text("Monthly Maintenance Cost: \$${property.monthlyMaintenanceCost.toStringAsFixed(2)}"),
              ElevatedButton(
                child: Text("Sell property"),
                onPressed: () {
                  _sellProperty(context, property);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sellProperty(BuildContext context, RealEstate property) {
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
                  realEstateService.sellRealEstate(property, account, person, transactionService);
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
