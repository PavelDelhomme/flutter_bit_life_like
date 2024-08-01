import 'package:flutter/material.dart';
import '../../services/bank/bank_account.dart';

class AccountManagementScreen extends StatelessWidget {
  final List<BankAccount> accounts;

  AccountManagementScreen({required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Your Accounts')),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          BankAccount account = accounts[index];
          return ListTile(
            title: Text('${account.bankName} - ${account.accountType}'),
            subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
            onTap: () => _showAccountDialog(context, account),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _closeAccount(context, account, index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewAccount(context),
        child: Icon(Icons.add),
        tooltip: 'Open New Account',
      ),
    );
  }

  void _showAccountDialog(BuildContext context, BankAccount account) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Account Number: ${account.accountNumber}'),
              Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              ElevatedButton(
                child: Text('Close Account'),
                onPressed: () {
                  _closeAccount(context, account);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _closeAccount(BuildContext context, BankAccount account, [int? index]) {
    if (account.balance >= account.closingFee) {
      account.closeAccount();
      if (index != null) {
        accounts.removeAt(index);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Account closed successfully."),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Insufficient funds to close the account."),
      ));
    }
  }

  void _addNewAccount(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String accountType;
    double initialDeposit;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a New Account'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: "Account Type"),
                  onSaved: (value) => accountType = value!,
                  validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Initial Deposit"),
                  onSaved: (value) => initialDeposit = double.parse(value!),
                  validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
                ),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // You would typically pass the bank object or similar here
                      // Example: yourBank.openAccount(accountType, initialDeposit, someInterestRate);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
