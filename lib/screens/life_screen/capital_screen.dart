import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';
import '../../services/bank/transaction_service.dart';
import '../capitals_management/antiques/my_antiques_screen.dart';
import '../capitals_management/banks/bank_account_screen.dart';
import '../capitals_management/electronics/electronics_screen.dart';
import '../capitals_management/jewelrys/my_jewelrys_screen.dart';
import '../capitals_management/real_estates/my_real_estates_screen.dart';
import '../capitals_management/vehicles/vehicules_screen.dart';
import '../market_place/marketplace_screen.dart';

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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                );
              },
            ),
            ListTile(
              title: Text("Vehicles"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyVehiclesScreen(person: widget.person)));
              },
            ),
            ListTile(
              title: Text("Jewelry"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyJewelrysScreen(person: widget.person)));
              },
            ),
            ListTile(
              title: Text("Electronics"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyElectronicsScreen(electronics: widget.person.electronics)));
              },
            ),
            ListTile(
              title: Text("Antiques"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyAntiquesScreen(person: widget.person)));
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Your Capital and Assets' : ''),
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
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}