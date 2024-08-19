import 'dart:developer';
import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_dealership_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicles/moto.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';

class MotoDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  MotoDealershipScreen({required this.person, required this.transactionService});

  Future<List<Moto>> loadMotos() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      List<dynamic> jsonResponse = json.decode(jsonString)['motorcycles'];

      List<Moto> motos = jsonResponse.map((m) => Moto.fromJson(m)).toList();
      log("Motorcycles loaded successfully");
      return motos;
    } catch (e) {
      log("Failed to load motorcycles: $e");
      throw Exception("Failed to load motorcycles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motorcycle Dealerships'),
      ),
      body: FutureBuilder<List<Moto>>(
        future: loadMotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log("Error loading motorcycles: ${snapshot.error}");
              return Center(child: Text("Error loading motorcycles"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No motorcycles available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Moto moto = snapshot.data![index];
                return ListTile(
                  title: Text(moto.name),
                  subtitle: Text('Price: \$${moto.value.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleDealerDetailsScreen(
                              vehicle: moto,
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
}
