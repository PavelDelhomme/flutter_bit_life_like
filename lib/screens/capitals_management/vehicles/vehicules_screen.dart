import 'package:flutter/material.dart';
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
    List<dynamic> allVehicles = [
      ...widget.person.voitures,
      ...widget.person.motos,
      ...widget.person.bateaux,
      ...widget.person.avions
    ];

    Map<String, List<dynamic>> vehicleCategories = {
      "All": allVehicles,
      "Airplaines": widget.person.avions,
      "Motos": widget.person.motos,
      "Bateaux": widget.person.bateaux,
      "Voitures": widget.person.voitures,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("My Vehicles"),
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
        itemCount: vehicleCategories[selectedCategory]!.length,
        itemBuilder: (context, index) {
          dynamic vehicle = vehicleCategories[selectedCategory]![index];
          return ListTile(
            title: Text(vehicle.name),
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