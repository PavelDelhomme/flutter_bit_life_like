import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';
import '../../../services/bank/FinancialService.dart';
import '../../../services/bank/bank_account.dart';

class CryptocurrencyInvestmentScreen extends StatefulWidget {
  final BankAccount account;
  final Person person;

  CryptocurrencyInvestmentScreen({required this.account, required this.person});

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
    if (FinancialService.instance.investInCrypto(widget.account, amountToInvest, widget.person)) {
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
