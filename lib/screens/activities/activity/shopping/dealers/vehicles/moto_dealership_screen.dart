import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';
import 'vehicle_details_screen.dart';

class MotoDealershipScreen extends StatelessWidget {
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
                      MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicle: moto)),
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
