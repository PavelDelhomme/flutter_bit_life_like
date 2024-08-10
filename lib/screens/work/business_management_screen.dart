// business_management_screen.dart
import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../screens/work/classes/business.dart';

class BusinessManagementScreen extends StatelessWidget {
  final Person person;

  BusinessManagementScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Management'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Start a New Business"),
            onTap: () {
              _showNewBusinessDialog(context);
            },
          ),
          ExpansionTile(
            title: Text("My Businesses"),
            children: person.businesses.map((business) {
              return ListTile(
                title: Text(business.name),
                subtitle: Text("Balance: \$${business.getBalance().toStringAsFixed(2)}"),
                onTap: () {
                  // Navigate to more details about the business
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showNewBusinessDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController investmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Start New Business"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Business Name"),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: "Business Type"),
              ),
              TextField(
                controller: investmentController,
                decoration: InputDecoration(labelText: "Initial Investment"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Start"),
              onPressed: () {
                String name = nameController.text;
                String type = typeController.text;
                double investment = double.parse(investmentController.text);

                person.startBusiness(name, type, investment);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
