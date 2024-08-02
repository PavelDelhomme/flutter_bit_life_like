import 'package:flutter/material.dart';

import '../../../../../../Classes/objects/real_estate.dart';
import '../../../../../../Classes/person.dart';
import '../../../../../../services/bank/transaction_service.dart';
import '../../../../../../services/real_estate/real_estate.dart';

class RealEstateClassicScreen extends StatelessWidget {
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final Person person;

  RealEstateClassicScreen({
    required this.realEstateService,
    required this.transactionService,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classic Real Estate Market'),
      ),
      body: FutureBuilder<List<RealEstate>>(
        future: realEstateService.getAvailableRealEstate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading real estate: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No classic real estate available."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RealEstate realEstate = snapshot.data![index];
                return ListTile(
                  title: Text(realEstate.name),
                  subtitle: Text('Price: \$${realEstate.value.toStringAsFixed(2)}'),
                  onTap: () {
                    // Handle navigation or purchase logic
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
