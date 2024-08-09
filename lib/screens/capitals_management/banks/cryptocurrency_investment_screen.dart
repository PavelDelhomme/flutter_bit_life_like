import 'package:flutter/material.dart';
import '../../../services/bank/FinancialService.dart';
import '../../../services/bank/bank_account.dart';

class CryptocurrencyInvestmentScreen extends StatefulWidget {
  final BankAccount account;

  CryptocurrencyInvestmentScreen({required this.account});

  @override
  _CryptocurrencyInvestmentScreenState createState() => _CryptocurrencyInvestmentScreenState();
}

class _CryptocurrencyInvestmentScreenState extends State<CryptocurrencyInvestmentScreen> {
  double amountToInvest = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cryptocurrency Investments"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount to Invest',
                suffix: Text('USD'),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                amountToInvest = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => investInCrypto(),
              child: Text('Invest in Cryptocurrency'),
            ),
          ],
        ),
      ),
    );
  }

  void investInCrypto() {
    if (FinancialService.instance.investInCrypto(widget.account, amountToInvest)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Investment Successful'),
          content: Text('You have successfully invested \$${amountToInvest.toStringAsFixed(2)} in cryptocurrency.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Investment Failed'),
          content: Text('Insufficient funds to complete the investment.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
