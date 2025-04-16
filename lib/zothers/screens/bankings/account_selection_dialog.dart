import 'package:flutter/material.dart';
import '../../../models/economy/bank_account.dart';

class AccountSelectionDialog extends StatelessWidget {
  final List<BankAccount> accounts;

  const AccountSelectionDialog({super.key, required this.accounts});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionner un compte'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(accounts[index].bankName),
            subtitle: Text(accounts[index].accountNumber),
            onTap: () => Navigator.pop(context, accounts[index]),
          ),
        ),
      ),
    );
  }
}