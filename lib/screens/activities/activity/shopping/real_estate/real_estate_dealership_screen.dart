import 'package:flutter/material.dart';
import '../../Classes/real_estate.dart';
import '../../Classes/person.dart';
import '../../services/loan_service.dart';
import '../../services/real_estate/real_estate.dart';
import '../../services/transaction_service.dart';

class RealEstateMarketScreen extends StatelessWidget {
  final RealEstateService realEstateService;
  final LoanService loanService;
  final TransactionService transactionService;
  final Person person;

  RealEstateMarketScreen({
    required this.realEstateService,
    required this.loanService,
    required this.transactionService,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Estate Market'),
      ),
      body: FutureBuilder<List<RealEstate>>(
        future: realEstateService.getAvailableRealEstate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                RealEstate realEstate = snapshot.data![index];
                return ListTile(
                  title: Text(realEstate.name),
                  subtitle: Text("\$${realEstate.value.toStringAsFixed(2)}"),
                  onTap: () => _buyRealEstate(context, realEstate),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _buyRealEstate(BuildContext context, RealEstate realEstate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Buy Real Estate"),
          content: Text("Do you want to buy ${realEstate.name} for \$${realEstate.value.toStringAsFixed(2)}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Pay Cash"),
              onPressed: () {
                Navigator.of(context).pop();
                transactionService.purchaseItem(
                  person.bankAccount,
                  realEstate.value,
                      () => print("Purchase successful!"),
                      () => print("Failed to purchase."),
                );
              },
            ),
            TextButton(
              child: Text("Apply for Loan"),
              onPressed: () {
                Navigator.of(context).pop();
                loanService.applyForLoan(
                  person.bankAccount,
                  realEstate.value,
                      () => print("Loan approved! Purchase successful!"),
                      () => print("Loan application failed."),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
