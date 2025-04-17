import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/shared/bank_account.dart';
import '../../../core/models/character.dart';
import '../../../core/ui/account_selection_dialog.dart';
import '../models/marketplace_item.dart';

class MarketplaceScreen extends StatelessWidget {
  final String title;
  final List<MarketplaceItem> items;
  final Function(MarketplaceItem) onPurchase;

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

  void _handlePurchase(BuildContext context, MarketplaceItem item) async {
    final character = Provider.of<Character>(context, listen: false);
    final account = await showDialog<BankAccount>(
      context: context,
      builder: (context) => AccountSelectionDialog(accounts: character.bankAccounts),
    );

    if (account != null) {
      onPurchase(item);
    }
  }
}
