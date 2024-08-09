import 'package:flutter/material.dart';

import '../../../../../../Classes/objects/real_estate.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/real_estate/real_estate.dart';

class RealEstateClassicScreen extends StatelessWidget {
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final Person person;

  RealEstateClassicScreen({
    required this.realEstateService,
    required this.transactionService,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classic Real Estate Market'),
      ),
      body: FutureBuilder<List<RealEstate>>(
        future: realEstateService.getPropertiesByTypeAndStyle("All", "Classic"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return Center(child: Text("Error loading real estate: ${snapshot.error}"));
            }

            print("Loaded estates: ${snapshot.data?.length}");

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No classic real estate available."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RealEstate realEstate = snapshot.data![index];
                return ListTile(
                  title: Text(realEstate.name),
                  subtitle: Text('Price: \$${realEstate.value.toStringAsFixed(2)}'),
                  onTap: () async {
                    _selectAccountAndPurchase(context, realEstate);
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
  void _selectAccountAndPurchase(BuildContext context, RealEstate realEstate) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: person.bankAccounts.map<Widget>((BankAccount account) => ListTile(
            title: Text('${account.bankName} - ${account.accountType}'),
            subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
            onTap: () async {
              Navigator.pop(context); // Close the modal bottom sheet
              bool success = await realEstateService.purchaseRealEstate(realEstate, account);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Purchase successful!")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Purchase failed. Check logs for details.")));
              }
            },
          )).toList(),
        );
      },
    );
  }

}