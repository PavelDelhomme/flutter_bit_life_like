import 'dart:developer';
import 'package:bit_life_like/Classes/life_history_event.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:bit_life_like/services/life_history.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicles/avion.dart';
import '../../../../../../services/bank/transaction_service.dart';

class AirplaneDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  AirplaneDealershipScreen({required this.person, required this.transactionService});

  Future<List<Avion>> loadAirplanes() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      List<dynamic> jsonResponse = json.decode(jsonString)['airplanes'];

      List<Avion> airplanes = jsonResponse.map((a) => Avion.fromJson(a)).toList();
      log("Airplanes loaded successfully");
      return airplanes;
    } catch (e) {
      log("Failed to load airplanes: $e");
      throw Exception("Failed to load airplanes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane Dealerships'),
      ),
      body: FutureBuilder<List<Avion>>(
        future: loadAirplanes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading airplanes: ${snapshot.error}");
              return Center(child: Text("Error loading airplanes"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No airplanes available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Avion airplane = snapshot.data![index];
                return ListTile(
                  title: Text(airplane.name),
                  subtitle: Text('Price: \$${airplane.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleDealerDetailsScreen(
                              vehicle: airplane,
                              person: person,
                              transactionService: transactionService
                          )
                      ),
                    );
                  },
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

  void _selectAccountAndPurchase(BuildContext context, Avion avion) {
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
                _attemptPurchase(context, account, avion);
              },
            );
          }).toList(),
        );
      },
    );
  }


  void _attemptPurchase(BuildContext context, BankAccount account, Avion plane) {
    transactionService.attemptPurchase(
        account,
        plane,
        onSuccess: () async {
          person.addVehicle(plane);

          final event = LifeHistoryEvent(
            description: "${person.name} purchased the plane ${plane.name} for \$${plane.value.toStringAsFixed(2)}.",
            timestamp: DateTime.now(),
            ageAtEvent: person.age,
            personId: person.id,
          );
          await LifeHistoryService().saveEvent(event);

          Navigator.pop(context);
          _showSuccessDialog(context, "You have successfully purchased the airplane ${plane.name}.");
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
