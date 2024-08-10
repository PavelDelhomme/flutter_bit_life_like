import 'package:flutter/material.dart';
import '../../../Classes/objects/real_estate.dart';
import '../../../Classes/person.dart';
import '../../../services/bank/transaction_service.dart';
import '../../../services/real_estate/real_estate.dart';

class MyRealEstateDetailsScreen extends StatelessWidget {
  final RealEstate estate;
  final RealEstateService realEstateService;
  final Person person;
  final TransactionService transactionService;

  MyRealEstateDetailsScreen({
    required this.estate,
    required this.realEstateService,
    required this.person,
    required this.transactionService
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of ${estate.name}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${estate.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Type: ${estate.type}", style: TextStyle(fontSize: 16)),
            Text("Age: ${estate.age} years", style: TextStyle(fontSize: 16)),
            Text("Value: \$${estate.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            Text("Condition: ${estate.condition}", style: TextStyle(fontSize: 16)),
            Text("Monthly Maintenance: \$${estate.monthlyMaintenanceCost.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // Remove the purchase buttons since the real estate is already owned.
            Text("This property is owned by you.", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
