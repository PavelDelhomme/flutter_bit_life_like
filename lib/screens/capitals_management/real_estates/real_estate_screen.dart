import 'package:bit_life_like/screens/capitals_management/real_estates/some_real_estate_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';

import '../../../Classes/objects/real_estate.dart';
import '../../../services/real_estate/real_estate.dart';

class RealEstatesScreen extends StatefulWidget {
  final Person person;
  final RealEstateService realEstateService;

  RealEstatesScreen({required this.person, required this.realEstateService});

  @override
  _RealEstatesScreenState createState() => _RealEstatesScreenState();
}

class _RealEstatesScreenState extends State<RealEstatesScreen> {
  String selectedType = "All";

  @override
  Widget build(BuildContext context) {
    List<RealEstate> filteredRealEstates = (selectedType == "All")
        ? widget.person.realEstates
        : widget.person.realEstates.where((estate) => estate.type == selectedType).toList();

    print("Displaying ${filteredRealEstates.length} real estates.");

    return Scaffold(
      appBar: AppBar(
        title: Text("Real Estates"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedType = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: "All", child: Text("All")),
              const PopupMenuItem<String>(value: "Villa", child: Text("Villa")),
              const PopupMenuItem<String>(value: "Appartement", child: Text("Appartement")),
              const PopupMenuItem<String>(value: "Maison", child: Text("Maison")),
              const PopupMenuItem<String>(value: "Studio", child: Text("Studio")),
              const PopupMenuItem<String>(value: "Manoir", child: Text("Manoir")),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredRealEstates.length,
        itemBuilder: (context, index) {
          var estate = filteredRealEstates[index];
          return ListTile(
            title: Text(estate.name),
            subtitle: Text("\$${estate.value.toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SomeRealEstateDetailsScreen(estate: estate, realEstateService: widget.realEstateService, person: widget.person),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
