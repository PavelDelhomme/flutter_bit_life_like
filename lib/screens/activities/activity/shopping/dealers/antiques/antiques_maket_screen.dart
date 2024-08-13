import 'package:flutter/material.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/antique/antique.dart';
import '../../../../../../services/bank/bank_account.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../Classes/objects/antique.dart';

class AntiqueMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;
  final AntiqueService antiqueService = AntiqueService();

  AntiqueMarketScreen({required this.person, required this.transactionService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Antique Market')),
      body: FutureBuilder<List<Antique>>(
        future: antiqueService.loadAntiques(), // Load antiques from the JSON file
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text('No antiques available.'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Antique antique = snapshot.data![index];
                return ListTile(
                  title: Text(antique.name),
                  subtitle: Text(
                      'Price: \$${antique.value.toStringAsFixed(2)}\nRarity: ${antique.rarity}\nEpoch: ${antique.epoch}'
                  ),
                  onTap: () => _purchaseAntique(context, antique),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _purchaseAntique(BuildContext context, Antique antique) {
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
        accountHolders: [],
      ),
    );

    /*if (account.accountNumber == "00000000") {
      _showErrorDialog(context, "No valid checking account available.");
    } else {
      _showPurchaseDialog(context, antique, account);
    }*/
    _showPurchaseDialog(context, antique, account);
  }

  void _showPurchaseDialog(BuildContext context, Antique antique, BankAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Buy Antique"),
          content: Text(
              "Do you want to buy ${antique.name} for \$${antique.value.toStringAsFixed(2)}?"
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Pay Cash"),
              onPressed: () {
                Navigator.of(context).pop();
                _attemptPurchase(account, antique, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _attemptPurchase(BankAccount account, Antique antique, BuildContext context) {
    transactionService.attemptPurchase(
      account,
      antique,
      onSuccess: () {
        person.antiques.add(antique); // Add the antique to the person's collection
        _showSuccessDialog(context);
      },
      onFailure: (String message) {
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
          content: Text("Congratulations! You have successfully purchased the antique."),
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
