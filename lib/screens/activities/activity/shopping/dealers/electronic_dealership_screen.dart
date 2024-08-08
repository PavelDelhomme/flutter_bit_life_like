import 'package:bit_life_like/screens/activities/activity/shopping/dealers/electronic_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../../../Classes/objects/electronic.dart';
import '../../../../../../Classes/person.dart';

class ElectronicDealershipScreen extends StatelessWidget {
  final Person person;

  ElectronicDealershipScreen({required this.person});

  Future<List<Electronic>> loadElectronics() async {
    try {
      String jsonString = await rootBundle.loadString('assets/electronics.json');
      Map<String, dynamic> jsonResponse = json.decode(jsonString);
      List<Electronic> electronics = jsonResponse['electronics']
          .map<Electronic>((e) => Electronic.fromJson(e))
          .toList();
      return electronics;
    } catch (e) {
      throw Exception('Failed to load electronics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electronics Dealership'),
      ),
      body: FutureBuilder<List<Electronic>>(
        future: loadElectronics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading electronics: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No electronics found."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Electronic electronic = snapshot.data![index];
                return ListTile(
                  title: Text('${electronic.brand} ${electronic.model}'),
                  subtitle: Text('Price: \$${electronic.price.toStringAsFixed(2)} | Type: ${electronic.type}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ElectronicsDetailsScreen(electronic: electronic)),
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
