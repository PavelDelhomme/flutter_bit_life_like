import 'package:flutter/material.dart';
import '../../../Classes/objects/real_estate.dart';
import '../../../Classes/person.dart';
import '../../../services/real_estate/real_estate.dart';
import '../../../services/bank/bank_account.dart';
import '../banks/loan_application_screen.dart';

class SomeRealEstateDetailsScreen extends StatelessWidget {
  final RealEstate estate;
  final RealEstateService realEstateService;
  final Person person;

  SomeRealEstateDetailsScreen({required this.estate, required this.realEstateService, required this.person});

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
            ElevatedButton(
                onPressed: () => _showPurchaseOptions(context, estate),
                child: Text('Buy or Apply for Loan')
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseOptions(BuildContext context, RealEstate estate) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Buy with cash'),
              onTap: () => _attemptPurchase(context, estate),
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Apply for loan'),
              onTap: () => _applyForLoan(context, estate),
            ),
          ],
        );
      },
    );
  }

  void _attemptPurchase(BuildContext context, RealEstate estate) {
    // Implementation needed: select account and then try purchase
  }

  void _applyForLoan(BuildContext context, RealEstate estate) {
    // Navigate to loan application, passing the first account for simplicity here
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoanApplicationScreen(account: person.bankAccounts.first),
      ),
    );
  }
}
