import 'package:flutter/material.dart';

import '../../Classes/person.dart';
import 'FinancialService.dart';
import 'bank_account.dart';

class OpenAccountScreen extends StatefulWidget {
  final Person person;

  OpenAccountScreen({required this.person});

  @override
  _OpenAccountScreenState createState() => _OpenAccountScreenState();
}

class _OpenAccountScreenState extends State<OpenAccountScreen> {
  late List<dynamic> _banks;
  String? _selectedBankName;
  String? _selectedAccountType;
  double _initialDeposit = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    _banks = await FinancialService.loadBankData();
    if (_banks.isNotEmpty) {
      setState(() {
        _selectedBankName = _banks.first['name'];
        _selectedAccountType = _banks.first['accounts'].first['type'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open New Account"),
      ),
      body: _banks.isEmpty
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _selectedBankName,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBankName = newValue!;
                          _selectedAccountType = _banks.firstWhere(
                                  (bank) => bank['name'] == newValue)['accounts'].first['type'];
                        });
                      },
                      items: _banks.map<DropdownMenuItem<String>>((bank) {
                        return DropdownMenuItem<String>(
                          value: bank['name'],
                          child: Text(bank['name']),
                        );
                      }).toList(),
                    ),
                    if (_selectedBankName != null) ...[
                      DropdownButton<String>(
                        value: _selectedAccountType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAccountType = newValue;
                          });
                          },
                        items: _banks
                            .firstWhere((bank) => bank['name'] == _selectedBankName)['accounts']
                            .map<DropdownMenuItem<String>>((account) {
                          return DropdownMenuItem<String>(
                            value: account['type'],
                            child: Text(account['type']),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Initial Deposit",
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _initialDeposit = double.tryParse(value) ?? 0;
                          },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _openAccount();
                          },
                        child: Text("Open Account"),
                      )
                    ]
                  ],
                ),
              ),
            ),
    );
  }

  void _openAccount() {
    if (_selectedBankName != null && _selectedAccountType != null) {
      final accountDetails = FinancialService.getBankAccountDetails(_selectedBankName!, _selectedAccountType!);
      if (accountDetails != null) {
        Bank bank = Bank(name: _selectedBankName!);
        BankAccount newAccount = bank.openAccount(
          _selectedAccountType!,
          _initialDeposit,
          accountDetails['interestRate'],
          isJoint: false,
        );
        widget.person.bankAccounts.add(newAccount);
        Navigator.pop(context);
      } else {
        // Handle cas when account details are not found
        print("Account details not found for $_selectedAccountType at $_selectedBankName.");
      }
    }
  }
}