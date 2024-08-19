import 'dart:developer';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/life_history_event.dart';
import '../../../../../../Classes/objects/vehicles/moto.dart';
import '../../../../../../Classes/objects/vehicles/voiture.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/life_history.dart';

class CarDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  CarDealershipScreen({required this.person, required this.transactionService});

  Future<List<dynamic>> loadVehicles() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);

      List<dynamic> cars = jsonResponse['cars'].map((v) => Voiture.fromJson(v)).toList();
      List<dynamic> motorcycles = jsonResponse['motorcycles'].map((m) => Moto.fromJson(m)).toList();

      return [...cars, ...motorcycles];
    } catch (e) {
      log("Failed to load vehicles: $e");
      throw Exception('Failed to load vehicles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car and Motorcycle Dealerships'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading vehicles: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No vehicles found."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                dynamic vehicle = snapshot.data![index];
                return ListTile(
                  title: Text(vehicle.name),
                  subtitle: Text('Price: \$${vehicle.value.toStringAsFixed(2)} | Type: ${vehicle.runtimeType}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleDealerDetailsScreen(
                              vehicle: vehicle,
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
  void _attemptPurchase(BuildContext context, BankAccount account, dynamic vehicle) {
    transactionService.attemptPurchase(
        account,
        vehicle,
        onSuccess: () async {
          person.addVehicle(vehicle);

          final event = LifeHistoryEvent(
            description: "${person.name} purchased the ${vehicle.runtimeType} ${vehicle.name} for \$${vehicle.value.toStringAsFixed(2)}.",
            timestamp: DateTime.now(),
            ageAtEvent: person.age,
            personId: person.id,
          );
          await LifeHistoryService().saveEvent(event);

          Navigator.pop(context);
          _showSuccessDialog(context, "You have successfully purchased the ${vehicle.runtimeType} ${vehicle.name}.");
        },
        onFailure: (String message) {
          _showErrorDialog(context, message);
        }
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Successful"),
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

  void _showErrorDialog(BuildContext context, String message) {
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
  }
}
