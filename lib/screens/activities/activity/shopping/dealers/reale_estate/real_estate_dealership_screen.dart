import 'package:flutter/material.dart';
import '../../../../../../Classes/objects/real_estate.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/real_estate/real_estate.dart';

class RealEstateMarketScreen extends StatelessWidget {
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final Person person;

  RealEstateMarketScreen({
    required this.realEstateService,
    required this.transactionService,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Immobilier'),
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
    BankAccount account = person.bankAccounts.firstWhere(
            (acc) => acc.accountType == "Checking",
        orElse: () => BankAccount(
            accountNumber: "00000000",
            bankName: "Default Bank",
            balance: 0.0,
            annualIncome: 0.0,
            monthlyExpenses: 0.0,
            loanTermYears: 0,
            interestRate: 0.0,
            accountType: "Default",
            closingFee: 0.0,
            accountHolders: []
        )
    );

    if (account.accountNumber == "00000000") {
      _showErrorDialog(context);
    } else {
      _showPurchaseDialog(context, realEstate, account);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("No checking account available."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, RealEstate realEstate, BankAccount account) {
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
                  account,
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
                if (account.canApplyForLoan(realEstate.value, realEstate.value / (account.loanTermYears * 12))) {
                  account.applyForLoan(realEstate.value, account.loanTermYears, account.interestRate);
                  _showSuccessDialog(context, realEstate);
                } else {
                  print("Loan application denied.");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, RealEstate realEstate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Successful"),
          content: Text("Congratulations! You have successfully purchased ${realEstate.name}."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
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
