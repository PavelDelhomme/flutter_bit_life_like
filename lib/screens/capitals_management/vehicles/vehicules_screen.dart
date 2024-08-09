import 'package:bit_life_like/screens/activities/activity/shopping/dealers/vehicles/vehicle_details_screen.dart';
import 'package:bit_life_like/screens/capitals_management/vehicles/vehicule_details_screen_capital.dart';
import 'package:flutter/material.dart';

import '../../../Classes/person.dart';


class MyVehiclesScreen extends StatefulWidget {
  final Person person;

  MyVehiclesScreen({required this.person});

  @override
  _MyVehiclesScreenState createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> vehiculeCategories = {
      "All": widget.person.vehicles,
      "Airplanes": widget.person.vehicles.where((v) => v.type == 'Airplane').toList(),
      "Motorcycles": widget.person.vehicles.where((v) => v.type == 'Motorcycle').toList(),
      "Boats": widget.person.vehicles.where((v) => v.type == 'Boat').toList(),
      "Cars": widget.person.vehicles.where((v) => v.type == 'Car').toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicles"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedCategory = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "All",
                child: Text("All"),
              ),
              const PopupMenuItem<String>(
                value: "Airplanes",
                child: Text("Airplanes"),
              ),
              const PopupMenuItem<String>(
                value: "Motorcycles",
                child: Text("Motorcycles"),
              ),
              const PopupMenuItem<String>(
                value: "Boats",
                child: Text("Boats"),
              ),
              const PopupMenuItem<String>(
                value: "Cars",
                child: Text("Cars"),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: vehiculeCategories[selectedCategory]!.length,
        itemBuilder: (context, index) {
          var vehicle = vehiculeCategories[selectedCategory]![index];
          return ListTile(
            title: Text(vehicle['name']),
            subtitle: Text("\$${vehicle['value'].toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehiculeDetailsScreenCapital(vehicle: vehicle),
                ),
              );
            },
          );
        },
      ),
    );
  }
}