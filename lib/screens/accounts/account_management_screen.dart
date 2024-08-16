import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Classes/ficalite/evasion_fiscale.dart';
import '../../services/bank/bank_account.dart';

class AccountManagementScreen extends StatefulWidget {
  final List<BankAccount> accounts;
  final List<OffshoreAccount> offshoreAccounts;
  final double annualIncome;
  final double netWorth;

  AccountManagementScreen({
    required this.accounts,
    required this.offshoreAccounts,
    required this.annualIncome,
    required this.netWorth,
  });

  @override
  _AccountManagementScreenState createState() => _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  late List<dynamic> bankData = [];

  @override
  void initState() {
    super.initState();
    _loadBankData();
  }

  Future<void> _loadBankData() async {
    final String response = await rootBundle.loadString('assets/banks.json');
    setState(() {
      bankData = json.decode(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Your Accounts')),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('Bank Accounts'),
            children: _buildAccountList(context, widget.accounts),
          ),
          ExpansionTile(
            title: Text('Offshore Accounts'),
            children: _buildAccountList(context, widget.offshoreAccounts),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewAccount(context),
        child: Icon(Icons.add),
        tooltip: 'Open New Account',
      ),
    );
  }

  List<Widget> _buildAccountList(BuildContext context, List<dynamic> accounts) {
    return accounts.map((account) {
      return ListTile(
        title: Text('${account.bankName} - ${account.accountType}'),
        subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
        onTap: () => _showAccountDialog(context, account),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => _closeAccount(context, account),
        ),
      );
    }).toList();
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
        widget.accounts.removeAt(index);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Account closed successfully."),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Insufficient funds to close the account."),
      ));
    }
  }

  void _addNewAccount(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? selectedBank;
    String? selectedAccountType;
    double initialDeposit = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a New Account'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(hintText: 'Select Bank'),
                  items: bankData.map<DropdownMenuItem<String>>((bank) {
                    return DropdownMenuItem<String>(
                      value: bank['name'],
                      child: Text(bank['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a bank': null,
                ),
                if (selectedBank != null) // Load account types when bank is selected
                  DropdownButtonFormField<String>(
                    decoration:
                    const InputDecoration(hintText: "Select Account Type"),
                    items: bankData
                        .firstWhere((bank) => bank['name'] == selectedBank)[
                    'accounts']
                        .map<DropdownMenuItem<String>>((account) {
                      return DropdownMenuItem<String>(
                        value: account['type'],
                        child: Text(account['type']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAccountType = value;
                      });
                    },
                    validator: (value) =>
                    value == null ? 'Please select an account type' : null,
                  ),
                TextFormField(
                  decoration:
                  const InputDecoration(hintText: "Initial Deposit"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) =>
                  initialDeposit = double.tryParse(value!) ?? 0.0,
                  validator: (value) =>
                  value!.isEmpty ? 'This field cannot be empty' : null,
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (selectedAccountType == "Offshore") {
                        _handleOffshoreAccount(selectedBank!, initialDeposit);
                      } else {
                        // Ajouter un compte régulier
                        BankAccount newAccount = BankAccount(
                          accountNumber: 'ACC${DateTime.now().millisecondsSinceEpoch}',
                          bankName: selectedBank!,
                          accountType: selectedAccountType!,
                          balance: initialDeposit,
                          interestRate: 0.1,
                        );
                        widget.accounts.add(newAccount);
                      }
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

  void _handleOffshoreAccount(String? bankName, double initialDeposit) {
    const double minimumIncomeRequired = 100000; // Revenu annuel minimum requis
    const double minimumNetWorthRequired = 500000; // Capital minimum requis

    // Vérifiez si l'utilisateur répond aux exigences pour ouvrir un compte offshore
    if (widget.annualIncome >= minimumIncomeRequired ||
        widget.netWorth >= minimumNetWorthRequired) {
      OffshoreAccount newOffshoreAccount = OffshoreAccount(
        accountNumber: 'OFF${DateTime.now().millisecondsSinceEpoch}',
        bankName: bankName ?? 'Unknown Offshore Bank',
        balance: initialDeposit,
        taxHavenCountry: "Cayman Islands", // Exemples, cela pourrait être plus dynamique
      );
      widget.offshoreAccounts.add(newOffshoreAccount);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Offshore account opened successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Cannot open offshore account: Minimum income or net worth requirements not met."),
        ),
      );
    }
  }
}