import 'package:flutter/material.dart';

import '../../../../../../Classes/objects/real_estate.dart';
import '../reale_estate_seller.dart';

class VillaMarketScreen extends StatelessWidget {
  final VillaSeller seller;

  VillaMarketScreen(this.seller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Villa Market'),
      ),
      body: FutureBuilder<List<RealEstate>>(
        future: seller.getProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                RealEstate realEstate = snapshot.data![index];
                return ListTile(
                  title: Text(realEstate.name),
                  subtitle: Text("\$${realEstate.value.toStringAsFixed(2)}"),
                  onTap: () => _buyRealEstate(context, realEstate),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _buyRealEstate(BuildContext context, RealEstate realEstate) {
    // Implémentation de l'achat comme mentionné précédemment
  }
}
