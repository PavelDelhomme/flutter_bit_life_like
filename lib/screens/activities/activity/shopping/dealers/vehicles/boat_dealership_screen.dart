import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../../../Classes/objects/vehicle.dart';

class BoatDealershipScreen extends StatelessWidget {
  Future<List<Bateau>> loadBoats() async {
    String jsonString = await rootBundle.loadString('lib/files/vehicles.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> boatsJson = jsonResponse['boats'];
    return boatsJson.map((v) => Bateau.fromJson(v)).toList();
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
              return Center(child: Text("Error loading boats"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Bateau boat = snapshot.data![index];
                return ListTile(
                  title: Text(boat.name),
                  subtitle: Text('Price: \$${boat.value.toStringAsFixed(2)}'),
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
