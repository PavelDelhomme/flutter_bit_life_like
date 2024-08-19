import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Classes/ficalite/evasion_fiscale.dart';
import '../../Classes/life_history_event.dart';
import '../../Classes/person.dart';
import '../../services/bank/bank_account.dart';
import '../../services/life_history.dart';

class AccountManagementScreen extends StatefulWidget {
  final List<BankAccount> accounts;
  final List<OffshoreAccount> offshoreAccounts;
  final double annualIncome;
  final double netWorth;
  final Person person;  // Ajoutez ceci pour avoir accès à la personne

  AccountManagementScreen({
    required this.accounts,
    required this.offshoreAccounts,
    required this.annualIncome,
    required this.netWorth,
    required this.person,  // Assurez-vous de passer la personne dans l'appel
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
          _buildAccountSection('Bank Accounts', widget.accounts),
          _buildAccountSection('Offshore Accounts', widget.offshoreAccounts),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewAccount(context),
        child: Icon(Icons.add),
        tooltip: 'Open New Account',
      ),
    );
  }

  Widget _buildAccountSection(String title, List<dynamic> accounts) {
    return ExpansionTile(
      title: Text(title),
      children: _buildAccountList(accounts),
    );
  }

  List<Widget> _buildAccountList(List<dynamic> accounts) {
    return accounts.map((account) {
      return ListTile(
        title: Text('${account.bankName} - ${account.accountType}'),
        subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
        onTap: () => _showAccountDialog(account),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => _closeAccount(account),
        ),
      );
    }).toList();
  }

  void _showAccountDialog(BankAccount account) {
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
                  _closeAccount(account);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _closeAccount(BankAccount account, [int? index]) async {
    if (account.balance >= account.closingFee) {
      account.closeAccount();
      if (index != null) {
        widget.accounts.removeAt(index);
      }

      // Ajout à l'historique de la vie
      final event = LifeHistoryEvent(
        description: "${widget.person.name} closed their ${account.accountType} account at ${account.bankName}.",
        timestamp: DateTime.now(),
        ageAtEvent: widget.person.age,
        personId: widget.person.id,  // Ajout de l'identifiant de la personne
      );
      await LifeHistoryService().saveEvent(event);

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
                  validator: (value) => value == null ? 'Please select a bank' : null,
                ),
                if (selectedBank != null)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(hintText: "Select Account Type"),
                    items: bankData.firstWhere((bank) => bank['name'] == selectedBank)['accounts']
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
                    validator: (value) => value == null ? 'Please select an account type' : null,
                  ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Initial Deposit"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) => initialDeposit = double.tryParse(value!) ?? 0.0,
                  validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
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

                        // Ajout à l'historique de la vie
                        final event = LifeHistoryEvent(
                          description: "${widget.person.name} opened a new ${newAccount.accountType} account at ${newAccount.bankName}.",
                          timestamp: DateTime.now(),
                          ageAtEvent: widget.person.age,
                          personId: widget.person.id,  // Ajout de l'identifiant de la personne
                        );
                        await LifeHistoryService().saveEvent(event);
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

  void _handleOffshoreAccount(String? bankName, double initialDeposit) async {
    const double minimumIncomeRequired = 100000; // Revenu annuel minimum requis
    const double minimumNetWorthRequired = 500000; // Capital minimum requis

    if (widget.annualIncome >= minimumIncomeRequired || widget.netWorth >= minimumNetWorthRequired) {
      OffshoreAccount newOffshoreAccount = OffshoreAccount(
        accountNumber: 'OFF${DateTime.now().millisecondsSinceEpoch}',
        bankName: bankName ?? 'Unknown Offshore Bank',
        balance: initialDeposit,
        taxHavenCountry: "Cayman Islands", // Exemples
      );
      widget.offshoreAccounts.add(newOffshoreAccount);

      // Ajout à l'historique de la vie
      final event = LifeHistoryEvent(
        description: "${widget.person.name} opened an offshore account in ${newOffshoreAccount.taxHavenCountry}.",
        timestamp: DateTime.now(),
        ageAtEvent: widget.person.age,
        personId: widget.person.id,  // Ajout de l'identifiant de la personne
      );
      await LifeHistoryService().saveEvent(event);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offshore account opened successfully.")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot open offshore account: Minimum income or net worth requirements not met.")));
    }
  }
}
