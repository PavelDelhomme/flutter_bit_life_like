import 'package:flutter/material.dart';

import '../../models/economy/bank_account.dart';
import '../../models/person/character.dart';

class MarketplaceScreen extends StatelessWidget {
  final String title;
  final List<MarketItem> items;
  final Function(MarketItem) onPurchase;

  const MarketplaceScreen({
    super.key,
    required this.title,
    required this.items,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => _handlePurchase(context, item),
            ),
          );
        },
      ),
    );
  }

  void _handlePurchase(BuildContext context, MarketItem item) async {
    final character = context.read<Character>();
    final account = await showDialog<BankAccount>(
      context: context,
      builder: (context) => AccountSelectionDialog(character.bankAccounts),
    );

    if (account != null && character.purchaseItem(item, account)) {
      onPurchase(item);
    }
  }
}
