import 'dart:convert';

import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';
import '../../../../../../Classes/person.dart';
import 'vehicle_dealership_details_screen.dart';

class MotoDealershipScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  MotoDealershipScreen({required this.person, required this.transactionService});

  Future<List<Moto>> loadMotos() async {
    String jsonString = await rootBundle.loadString('lib/files/vehicles.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> motosJson = jsonResponse['motorcycles'];
    return motosJson.map((v) => Moto.fromJson(v)).toList();
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
              return Center(child: Text("Error loading motorcycles"));
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
                      MaterialPageRoute(builder: (context) => VehicleDealerDetailsScreen(vehicle: moto, person: person, transactionService: transactionService)),
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
