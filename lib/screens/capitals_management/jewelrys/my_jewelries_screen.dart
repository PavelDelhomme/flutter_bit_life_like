import 'package:bit_life_like/services/jewelry/jewelry.dart';
import 'package:flutter/material.dart';

import '../../../Classes/person.dart';
import 'my_jewelry_details_screen.dart';
import '../../../Classes/objects/jewelry.dart';
import '../../../services/bank/transaction_service.dart';

class MyJewelriesScreen extends StatefulWidget {
  final Person person;
  final JewelryService jewelryService;
  final TransactionService transactionService;

  MyJewelriesScreen({
    required this.person,
    required this.jewelryService,
    required this.transactionService,
  });

  @override
  _MyJewelriesScreenState createState() => _MyJewelriesScreenState();
}

class _MyJewelriesScreenState extends State<MyJewelriesScreen> {
  String selectedBrand = "All";

  @override
  Widget build(BuildContext context) {
    List<Jewelry> filteredJewelries = (selectedBrand == "All")
        ? widget.person.jewelries
        : widget.person.jewelries.where((jewelry) => jewelry.brand == selectedBrand).toList();

    print("Displaying ${filteredJewelries.length} jewelries.");

    return Scaffold(
      appBar: AppBar(
        title: Text("My Jewelries"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value){
              setState(() {
                selectedBrand = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: "All", child: Text("All")),
              const PopupMenuItem<String>(value: "Tiffany", child: Text("Tiffany")),
              const PopupMenuItem<String>(value: "Cartier", child: Text("Cartier")),
              const PopupMenuItem<String>(value: "Bvlgari", child: Text("Bvlgari")),
              const PopupMenuItem<String>(value: "Van Cleef & Arpels", child: Text("Van Cleef & Arpels")),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredJewelries.length,
        itemBuilder: (context, index) {
          var jewelry = filteredJewelries[index];
          return ListTile(
            title: Text(jewelry.name),
            subtitle: Text("\$${jewelry.value.toStringAsFixed(2)} - ${jewelry.material}, ${jewelry.carat} carat"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyJewelryDetailsScreen(
                    jewelry: jewelry,
                    jewelryService: widget.jewelryService,
                    person: widget.person,
                    transactionService: widget.transactionService,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
