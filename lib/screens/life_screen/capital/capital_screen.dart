import 'dart:developer';

import 'package:bit_life_like/screens/life_screen/capital/personal_tax_screen.dart';
import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';
import '../../../Classes/ficalite/evasion_fiscale.dart';
import '../../../services/bank/transaction_service.dart';
import '../../../services/jewelry/jewelry.dart';
import '../../capitals_management/antiques/my_antiques_screen.dart';
import '../../capitals_management/banks/bank_account_screen.dart';
import '../../capitals_management/electronics/electronics_screen.dart';
import '../../capitals_management/jewelrys/my_jewelries_screen.dart';
import '../../capitals_management/real_estates/my_real_estates_screen.dart';
import '../../capitals_management/vehicles/vehicules_screen.dart';
import '../../market_place/marketplace_screen.dart';

class CapitalScreen extends StatefulWidget {
  final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;

  CapitalScreen({
    required this.person,
    required this.realEstateService,
    required this.transactionService,
  });

  @override
  _CapitalScreenState createState() => _CapitalScreenState();
}

class _CapitalScreenState extends State<CapitalScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() => <Widget>[
    buildAssetsView(),
    MarketplaceScreen(
      person: widget.person,
      transactionService: widget.transactionService,
      realEstateService: widget.realEstateService,
    ),
    buildFinancialSummary(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketplaceScreen(
            person: widget.person,
            transactionService: widget.transactionService,
            realEstateService: widget.realEstateService,
          ),
        ),
      ).then((result) {
        if (result != null && result is String) {
          Navigator.pop(context, result); // Propager le résultat à HomeScreen
        }
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }



  Widget buildAssetsView() {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text("Bank Accounts"),
          children: <Widget>[
            ListTile(
              title: Text("View Accounts"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BankAccountScreen(person: widget.person)));
              },
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Investments"),
          children: <Widget>[
            ListTile(
              title: Text("Stock Market"),
              onTap: () {
                // Navigate to Stock Market Screen
              },
            ),
            ListTile(
              title: Text("Cryptocurrencies"),
              onTap: () {
                // Navigate to Cryptocurrency Investment Screen
              },
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Properties"),
          children: <Widget>[
            ListTile(
              title: Text("Real Estate"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyRealEstatesScreen(
                      person: widget.person,
                      realEstateService: widget.realEstateService,
                      transactionService: widget.transactionService,
                    ),
                  ),
                ).then((result) {
                  if (result != null && result is String) {
                    Navigator.pop(context, result); // Propager le résultat vers l'appelant
                  }
                });
              },
            ),
            ListTile(
              title: Text("Vehicles"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyVehiclesScreen(person: widget.person)))
                    .then((result) {
                  if (result != null && result is String) {
                    Navigator.pop(context, result); // Propager le résultat vers l'appelant
                  }
                });
              },
            ),
            ListTile(
              title: Text("Jewelry"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyJewelriesScreen(
                      person: widget.person,
                      jewelryService: JewelryService(),
                      transactionService: TransactionService(),
                    ),
                  ),
                ).then((result) {
                  if (result != null && result is String) {
                    Navigator.pop(context, result); // Propager le résultat vers l'appelant
                  }
                });
              },
            ),
            ListTile(
              title: Text("Electronics"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyElectronicsScreen(electronics: widget.person.electronics)))
                    .then((result) {
                  if (result != null && result is String) {
                    Navigator.pop(context, result); // Propager le résultat vers l'appelant
                  }
                });
              },
            ),
            ListTile(
              title: Text("Antiques"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyAntiquesScreen(person: widget.person)))
                    .then((result) {
                  if (result != null && result is String) {
                    Navigator.pop(context, result); // Propager le résultat vers l'appelant
                  }
                });
              },
            ),
            ListTile(
              title: Text("Manage Taxes"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalTaxScreen(person: widget.person),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFinancialSummary() {
    double monthlyIncome = widget.person.calculateMonthlyIncome();
    double monthlyExpenses = widget.person.calculateMonthlyExpenses();
    double netWorth = widget.person.calculateNetWorth(excludeOffshore: false);
    double totalDebt = widget.person.bankAccounts.fold(0.0, (sum, acc) => sum + acc.totalDebt());

    return ListView(
      children: [
        ListTile(
          title: Text("Total Monthly Income"),
          subtitle: Text("\$${monthlyIncome.toStringAsFixed(2)}"),
        ),
        ListTile(
          title: Text("Total Monthly Expenses"),
          subtitle: Text("\$${monthlyExpenses.toStringAsFixed(2)}"),
        ),
        ListTile(
          title: Text("Total Debt"),
          subtitle: Text("\$${totalDebt.toStringAsFixed(2)}"),
        ),
        ListTile(
          title: Text("Net Worth"),
          subtitle: Text("\$${netWorth.toStringAsFixed(2)}"),
        ),
        Divider(),
        ListTile(
          title: Text("Annual Taxes Overview"),
          subtitle: Text("Click below to manage your taxes"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalTaxScreen(person: widget.person),
              ),
            );
          },
          child: Text("Manage Personal Taxes"),
        ),
        ElevatedButton(
          onPressed: () {
            _showTaxHavenOptions(context);
          },
          child: Text("Manage Offshore Accounts"),
        ),
      ],
    );
  }

  void _showTaxHavenOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Manage Offshore Accounts"),
          content: Text("Would you like to create a new offshore account?"),
          actions: <Widget>[
            TextButton(
              child: Text("Create Account"),
              onPressed: () {
                OffshoreAccount account = TaxHavenService.createOffshoreAccount(widget.person, 10000.0); // Montant initial
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Offshore account created in ${account.taxHavenCountry}.")),
                );
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? 'Your Capital and Assets'
            : _selectedIndex == 1
              ? 'Marketplace'
              : 'Financial Summary'),
      ),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Assets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Summary',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
