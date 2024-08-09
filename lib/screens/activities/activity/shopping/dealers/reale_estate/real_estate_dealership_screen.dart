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

  RealEstateMarketScreen({required this.realEstateService, required this.transactionService, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real Estate Market")),
      body: FutureBuilder<List<RealEstate>>(
        future: realEstateService.getAllPropertiesWithoutTypeAndStyle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No properties found."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RealEstate estate = snapshot.data![index];
                return ListTile(
                  title: Text(estate.name),
                  subtitle: Text('Price: \$${estate.value.toStringAsFixed(2)}'),
                  onTap: () => _buyRealEstate(context, estate),
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
            accountHolders: []));

    if (account.accountNumber == "00000000") {
      _showErrorDialog(context, "No valid checking account available.");
    } else {
      _showPurchaseDialog(context, realEstate, account);
    }
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
                _attemptPurchase(account, realEstate, context);
              },
            ),
            TextButton(
              child: Text("Apply for Loan"),
              onPressed: () {
                Navigator.of(context).pop();
                _attemptLoan(account, realEstate, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _attemptPurchase(BankAccount account, RealEstate realEstate, BuildContext context) {
    transactionService.attemptPurchase(
      account,
      realEstate,
      onSuccess: () {
        print("Purchase successful!");
        _showSuccessDialog(context);
      },
      onFailure: (String message) {
        print("Failed to purchase.");
        _showErrorDialog(context, message);
      },
    );
  }

  void _attemptLoan(BankAccount account, RealEstate realEstate, BuildContext context) {
    transactionService.attemptPurchase(
      account,
      realEstate,
      useLoan: true,
      loanTerm: 30, // Example loan term
      loanInterestRate: 5.0, // Example interest rate
      onSuccess: () {
        print("Loan approved and purchase successful!");
        _showSuccessDialog(context);
      },
      onFailure: (String message) {
        print("Loan application denied.");
        _showErrorDialog(context, message);
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Successful"),
          content: Text("Congratulations! You have successfully purchased the property."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
