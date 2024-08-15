import 'package:bit_life_like/screens/work/company_management/real_estate_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:bit_life_like/Classes/person.dart';
import '../../services/bank/transaction_service.dart';
import '../../services/jewelry/jewelry.dart';
import '../../services/real_estate/real_estate.dart';
import '../activities/activity/shopping/dealers/antiques/antiques_maket_screen.dart';
import '../activities/activity/shopping/dealers/electronic/electronic_dealership_screen.dart';
import '../activities/activity/shopping/dealers/jewelry/jewelry_market_screen.dart';
import '../activities/activity/shopping/dealers/reale_estate/sub_class/real_estate_classic_screen.dart';
import '../activities/activity/shopping/dealers/reale_estate/sub_class/real_estate_exotic_screen.dart';
import '../activities/activity/shopping/dealers/seconde_main_market_screen.dart';
import '../activities/activity/shopping/dealers/vehicles/vehicle_dealership_screen.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Marketplace"),
        ),
        body: ListView(
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
                            ).then((result) {
                              if (result != null && result is String) {
                                Navigator.pop(context, result);
                              }
                            });
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
                            ).then((result) {
                              if (result != null && result is String) {
                                Navigator.pop(context, result);
                              }
                            });
                          },
                          child: const Text('Exotic'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RealEstateManagementScreen(
                                  properties: person.realEstates,
                                  realEstateService: realEstateService,
                                  transactionService: transactionService,
                                  person: person,
                                ),
                              ),
                            ).then((result) {
                              if (result != null && result is String) {
                                Navigator.pop(context, result);
                              }
                            });
                          },
                          child: const Text("Business Real Estate"),
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
              ).then((result) {
                if (result != null && result is String) {
                  Navigator.pop(context,
                      result); // Retourner le résultat à Capital Screen
                }
              }),
            ),
            ListTile(
              title: Text('Jewelry Market'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JewelryMarketScreen(
                    person: person,
                    transactionService: transactionService,
                    jewelryService: JewelryService(),
                  ),
                ),
              ).then((result) {
                if (result != null && result is String) {
                  Navigator.pop(context, result);
                }
              }),
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
              ).then((result) {
                if (result != null && result is String) {
                  Navigator.pop(context, result);
                }
              }),
            ),
            ListTile(
              title: Text("Seconde Main Market"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondHandMarketScreen(
                    person: person,
                    transactionService: transactionService,
                  ),
                ),
              ).then((result) {
                if (result != null && result is String) {
                  Navigator.pop(context, result);
                }
              }),
            ),
          ],
        ));
  }
}
