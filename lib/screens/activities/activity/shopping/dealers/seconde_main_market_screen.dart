import 'package:flutter/material.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';

// Assurez-vous que ce fichier est correct, mais pour l'instant, nous n'importons pas BankAccount ou Antique.

class SecondHandMarketScreen extends StatelessWidget {
  final Person person;
  final TransactionService transactionService;

  SecondHandMarketScreen({
    required this.person,
    required this.transactionService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Hand Market'),
      ),
      body: Center(
        child: Text(
          'Second Hand Market Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
