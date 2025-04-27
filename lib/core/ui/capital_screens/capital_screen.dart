import 'package:flutter/material.dart';
import '../../models/character.dart';

class CapitalScreen extends StatelessWidget {
  final Character character;

  const CapitalScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capital")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Comptes bancaires :', style: TextStyle(fontSize: 18)),
          ...character.bankAccounts.map((acc) => ListTile(
            title: Text('${acc.bankName} (${acc.accountType.name})'),
            subtitle: Text('${acc.balance.toStringAsFixed(2)} \$'),
          )),
          const Divider(),
          const Text('Assets possédés :', style: TextStyle(fontSize: 18)),
          ...character.assets.map((asset) => ListTile(
            title: Text(asset.name),
            subtitle: Text('${asset.value.toStringAsFixed(2)} \$'),
          )),
          ...character.vehicles.map((v) => ListTile(
            title: Text(v.model),
            subtitle: Text('${v.value.toStringAsFixed(2)} \$'),
          )),
          ...character.properties.map((p) => ListTile(
            title: Text(p.name),
            subtitle: Text('${p.value.toStringAsFixed(2)} \$'),
          )),
        ],
      ),
    );
  }
}
