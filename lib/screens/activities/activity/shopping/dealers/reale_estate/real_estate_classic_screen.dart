import 'package:flutter/material.dart';

import '../../../../../../Classes/objects/real_estate.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/real_estate/real_estate.dart';

class RealEstateClassicScreen extends StatefulWidget {
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final Person person;

  RealEstateClassicScreen({
    required this.realEstateService,
    required this.transactionService,
    required this.person,
  });

  @override
  _RealEstateClassicScreenState createState() =>
      _RealEstateClassicScreenState();
}

class _RealEstateClassicScreenState extends State<RealEstateClassicScreen> {
  String selectedType = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Classic Real Estate Market'),
          actions: <Widget>[
            DropdownButton<String>(
              value: selectedType,
              icon: Icon(Icons.arrow_downward),
              onChanged: (String? newValue) {
                setState(() {
                  selectedType = newValue!;
                });
              },
              items: <String>[
                'All',
                'Villa',
                'Appartment',
                'Maison',
                'Studio',
                'Cottage',
                'Duplex',
                'Loft',
                'Bungalow',
                'Penthouse',
                "Maison de ville",
                'Condo',
                'Chalet',
                'Manoir',
                'Maison jumelée',
                'Condominium',
                'Domaine',
                'Résidence',
                'Garage',
                'Immeuble',
                'Gratte-ciel',
                'Immeuble commercial',
                'Immeuble mixte',
                'Attique',
                'Château'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        body: FutureBuilder<List<RealEstate>>(
          future: widget.realEstateService
              .getPropertiesByTypeAndStyle(selectedType, "Classic"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child:
                        Text("Error loading real estate: ${snapshot.error}"));
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text("No classic real estate available."));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  RealEstate realEstate = snapshot.data![index];
                  return ListTile(
                    title: Text(realEstate.name),
                    subtitle:
                        Text('Price: \$${realEstate.value.toStringAsFixed(2)}'),
                    onTap: () => _selectAccountAndPurchase(context, realEstate),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  void _selectAccountAndPurchase(BuildContext context, RealEstate realEstate) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children:
              widget.person.bankAccounts.map<Widget>((BankAccount account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle:
                  Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _showPurchaseOptions(context, realEstate, account),
            );
          }).toList(),
        );
      },
    );
  }

  void _showPurchaseOptions(BuildContext context, RealEstate realEstate, BankAccount account) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Purchase Options"),
          content: Text("Choose your payment method for ${realEstate.name}."),
          actions: <Widget>[
            TextButton(
              child: Text("Pay Cash"),
              onPressed: () {
                Navigator.pop(context);
                _attemptPurchase(account, realEstate, context);
              },
            ),
            TextButton(
              child: Text("Apply For Loan"),
              onPressed: () {
                Navigator.pop(context);
                _attemptLoan(account, realEstate, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _attemptPurchase(BankAccount account, RealEstate realEstate, BuildContext context) {
    widget.transactionService.attemptPurchase(
        account,
        realEstate,
        onSuccess: () {
          Navigator.pop(context); // Close the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Purchase Successful"),
                content: Text("You have successfully purchased ${realEstate.name}."),
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
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Purchase Failed"),
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
    );
  }

  void _attemptLoan(BankAccount account, RealEstate realEstate, BuildContext context) {
    widget.transactionService.attemptPurchase(
        account,
        realEstate,
        useLoan: true,
        loanTerm: 30, // Example loan term
        loanInterestRate: 5.0, // Example interest rate
        onSuccess: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Loan Approved"),
                content: Text("Loan approved and ${realEstate.name} purchased."),
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
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Loan Denied"),
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
    );
  }
}
