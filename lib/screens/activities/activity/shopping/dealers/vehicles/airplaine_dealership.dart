import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';

class AvionDealershipScreen extends StatelessWidget {
  Future<List<Avion>> loadAirplanes() async {
    String jsonString = await rootBundle.loadString('lib/files/vehicles.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> airplanesJson = jsonResponse['airplanes'];
    return airplanesJson.map((v) => Avion.fromJson(v)).toList();
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
              return Center(child: Text("Error loading airplanes"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Avion airplane = snapshot.data![index];
                return ListTile(
                  title: Text(airplane.name),
                  subtitle: Text('Price: \$${airplane.value.toStringAsFixed(2)}'),
                  onTap: () {
                    // Actions on tap, like showing details or initiating a purchase
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
