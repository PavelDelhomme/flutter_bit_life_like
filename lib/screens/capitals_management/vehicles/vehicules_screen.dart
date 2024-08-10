import 'package:flutter/material.dart';
import '../../../Classes/objects/vehicle.dart';
import '../../../Classes/person.dart';
import 'vehicule_details_screen_capital.dart';

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
    Map<String, List<Vehicle>> vehiculeCategories = {
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
          Vehicle vehicle = vehiculeCategories[selectedCategory]![index];
          return ListTile(
            title: Text(vehicle.name), // Access property directly
            subtitle: Text("\$${vehicle.value.toStringAsFixed(2)}"),
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
