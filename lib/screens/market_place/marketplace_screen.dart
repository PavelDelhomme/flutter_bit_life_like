import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import '../../services/bank/transaction_service.dart';
import '../../services/real_estate/real_estate.dart';
import '../activities/activity/shopping/dealers/antiques/antiques_maket_screen.dart';
import '../activities/activity/shopping/dealers/electronic/electronic_dealership_screen.dart'; // Ensure the import is correct
import '../activities/activity/shopping/dealers/jewelry/jewelry_market_screen.dart';
import '../activities/activity/shopping/dealers/reale_estate/sub_class/real_estate_classic_screen.dart';
import '../activities/activity/shopping/dealers/reale_estate/sub_class/real_estate_exotic_screen.dart';
import '../activities/activity/shopping/dealers/vehicles/vehicle_dealership_screen.dart'; // Import the new screen

class MarketplaceScreen extends StatelessWidget {
  final Person person;
  final RealEstateService realEstateService;
  final TransactionService transactionService;

  MarketplaceScreen({
    required this.person,
    required this.transactionService,
    required this.realEstateService,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Vehicle Market'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleDealershipScreen(
                person: person,
                transactionService: transactionService,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text('Real Estate Market'),
          subtitle: Text('Tap to select a category'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('Category'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RealEstateClassicScreen(
                              realEstateService: realEstateService,
                              transactionService: transactionService,
                              person: person,
                            ),
                          ),
                        );
                      },
                      child: const Text('Classic'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RealEstateExoticScreen(
                              realEstateService: realEstateService,
                              transactionService: transactionService,
                              person: person,
                            ),
                          ),
                        );
                      },
                      child: const Text('Exotic'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          title: Text('Antiques Market'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AntiqueMarketScreen(
                person: person,
                transactionService: transactionService,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text('Jewelry Market'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JewelryMarketScreen(
                person: person,
                transactionService: transactionService,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text('Electronics Market'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ElectronicMarketScreen(
                person: person,
                transactionService: transactionService,
              ),
            ),
          ),
        ),
      ],
    );
  }
}