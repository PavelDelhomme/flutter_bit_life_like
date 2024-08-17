import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import '../../../Classes/ficalite/evasion_fiscale.dart';
import '../../../services/bank/open_account_screen.dart';
import 'account_details_screen.dart';

class BankAccountScreen extends StatefulWidget {
  final Person person;

  BankAccountScreen({required this.person});

  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, List<BankAccount>> groupedAccounts = {};
    Map<String, List<OffshoreAccount>> groupedOffshoreAccounts = {};

    // Groupement des comptes bancaires ordinaires
    for (var account in widget.person.bankAccounts) {
      groupedAccounts.putIfAbsent(account.bankName, () => []).add(account);
    }

    // Groupement des comptes offshore
    for (var offshoreAccount in widget.person.offshoreAccounts) {
      groupedOffshoreAccounts.putIfAbsent(offshoreAccount.bankName, () => []).add(offshoreAccount);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Accounts"),
      ),
      body: ListView(
        children: [
          // Affichage des comptes bancaires ordinaires
          ExpansionTile(
            title: Text("Regular Bank Accounts"),
            children: groupedAccounts.keys.map((bankName) {
              List<BankAccount> accounts = groupedAccounts[bankName]!;
              return ExpansionTile(
                title: Text(bankName),
                children: accounts.map((account) => ListTile(
                  title: Text('${account.accountType}'),
                  subtitle: Text("Balance: \$${account.balance.toStringAsFixed(2)}\nInterest Rate: ${account.interestRate}%"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountDetailsScreen(account: account, person: widget.person),
                      ),
                    );
                  },
                )).toList(),
              );
            }).toList(),
          ),

          // Affichage des comptes offshore
          ExpansionTile(
            title: Text("Offshore Accounts"),
            children: groupedOffshoreAccounts.keys.map((bankName) {
              List<OffshoreAccount> offshoreAccounts = groupedOffshoreAccounts[bankName]!;
              return ExpansionTile(
                title: Text(bankName),
                children: offshoreAccounts.map((offshoreAccount) => ListTile(
                  title: Text('${offshoreAccount.accountType}'),
                  subtitle: Text("Balance: \$${offshoreAccount.balance.toStringAsFixed(2)}\nTax Haven: ${offshoreAccount.taxHavenCountry}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountDetailsScreen(account: offshoreAccount, person: widget.person),
                      ),
                    );
                  },
                )).toList(),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAccount = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OpenAccountScreen(person: widget.person)),
          );

          if (newAccount != null && newAccount is BankAccount) {
            setState(() {
              widget.person.bankAccounts.add(newAccount);
            });
          } else if (newAccount != null && newAccount is OffshoreAccount) {
            setState(() {
              widget.person.offshoreAccounts.add(newAccount);
            });
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Open New Account',
      ),
    );
  }
}
