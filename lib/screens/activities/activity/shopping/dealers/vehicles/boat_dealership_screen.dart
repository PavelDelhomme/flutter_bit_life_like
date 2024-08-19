import 'dart:developer';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/life_history_event.dart';
import '../../../../../../Classes/objects/vehicles/bateau.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/life_history.dart';

class BoatDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  BoatDealershipScreen({required this.person, required this.transactionService});

  Future<List<Bateau>> loadBoats() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      List<dynamic> jsonResponse = json.decode(jsonString)['boats'];

      List<Bateau> boats = jsonResponse.map((b) => Bateau.fromJson(b)).toList();
      log("Boats loaded successfully");
      return boats;
    } catch (e) {
      log("Failed to load boats: $e");
      throw Exception("Failed to load boats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boat Dealerships'),
      ),
      body: FutureBuilder<List<Bateau>>(
        future: loadBoats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading boats: ${snapshot.error}");
              return Center(child: Text("Error loading boats"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No boats available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Bateau boat = snapshot.data![index];
                return ListTile(
                  title: Text(boat.name),
                  subtitle: Text('Price: \$${boat.value.toStringAsFixed(2)}'),
                  onTap: () {
                    _selectAccountAndPurchase(context, boat);
                  },
                );
              },
            );
          } else {
            log("Loading boats...");
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _selectAccountAndPurchase(BuildContext context, Bateau boat) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: person.bankAccounts.map<Widget>((BankAccount account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(bc); // Fermer le bottom sheet avant de continuer
                _attemptPurchase(context, account, boat);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, BankAccount account, Bateau boat) {
    transactionService.attemptPurchase(
        account,
        boat,
        onSuccess: () async {
          person.addVehicle(boat);

          final event = LifeHistoryEvent(
            description: "${person.name} purchased the boat ${boat.name} for \$${boat.value.toStringAsFixed(2)}.",
            timestamp: DateTime.now(),
            ageAtEvent: person.age,
            personId: person.id,
          );
          await LifeHistoryService().saveEvent(event);

          Navigator.pop(context);
          _showSuccessDialog(context, "You have successfully purchased the boat ${boat.name}.");
        },
        onFailure: (String message) {
          _showErrorDialog(context, message);
        }
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
                Navigator.of(dialogContext).pop(); // Fermer le dialogue
                Navigator.of(context).pop(); // Fermer l'écran d'achat
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
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fermer le dialogue
              },
            ),
          ],
        );
      },
    );
  }
}
