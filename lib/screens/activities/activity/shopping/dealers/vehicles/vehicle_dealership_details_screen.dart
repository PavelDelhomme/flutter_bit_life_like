import 'package:flutter/material.dart';
import '../../../../../../Classes/objects/vehicle.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';

class VehicleDealerDetailsScreen extends StatelessWidget {
  final Vehicle vehicle;
  final Person person;
  final TransactionService transactionService;

  VehicleDealerDetailsScreen({
    required this.vehicle,
    required this.person,
    required this.transactionService,
  });

  void _purchaseVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Purchase Options"),
          content: Text("Choose your payment method for ${vehicle.name}."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _selectAccountAndPurchase(context, vehicle, false);
              },
              child: Text("Pay Cash"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _selectAccountAndPurchase(context, vehicle, true);
              },
              child: Text("Apply For Loan"),
            ),
          ],
        );
      },
    );
  }

  void _selectAccountAndPurchase(BuildContext context, Vehicle vehicle, bool useLoan) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((BankAccount account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(bc); // Close the bottom sheet before continuing
                _attemptPurchase(context, vehicle, account, useLoan);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, Vehicle vehicle, BankAccount account, bool useLoan) {
    final parentContext = context; // Save the context for use in callbacks
    transactionService.attemptPurchase(
      account,
      vehicle,
      useLoan: useLoan,
      loanTerm: 5, // Example loan term in years
      loanInterestRate: 3.5, // Example interest rate
      onSuccess: () {
        person.addVehicle(vehicle); // Add the vehicle to the person's collection
        _showSuccessDialog(parentContext, "You have successfully purchased the ${vehicle.name}.");
      },
      onFailure: (String message) {
        _showErrorDialog(parentContext, message);
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Purchase Successful"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Close the purchase screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  void _negotiatePrice(BuildContext context) {
    final _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Negotiate Price"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter your offer"),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle the offer submission
                Navigator.of(dialogContext).pop();
              },
              child: Text("Submit Offer"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${vehicle.name}", style: TextStyle(fontSize: 18)),
            Text("Type: ${vehicle.type}", style: TextStyle(fontSize: 18)),
            Text("Age: ${vehicle.age} years", style: TextStyle(fontSize: 18)),
            Text("Value: \$${vehicle.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
            Text("Rarity: ${vehicle.rarity}", style: TextStyle(fontSize: 18)),
            Text("Brand: ${vehicle.brand ?? 'N/A'}", style: TextStyle(fontSize: 18)),
            Text("Fuel Consumption: ${vehicle.fuelConsumption} L/100km", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _purchaseVehicle(context),
              child: Text('Purchase'),
            ),
            ElevatedButton(
              onPressed: () => _negotiatePrice(context),
              child: Text('Negotiate Price'),
            ),
          ],
        ),
      ),
    );
  }
}
