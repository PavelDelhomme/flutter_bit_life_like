import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/jewelry.dart';
import '../bank/bank_account.dart';

class JewelryService {
  List<Jewelry>? allJewelries;

  Future<void> loadAllJewelries() async {
    if (allJewelries != null) return;
    try {
      String jsonString = await rootBundle.loadString('assets/jewelry.json');
      var decoded = json.decode(jsonString);
      allJewelries = (decoded['jewelry'] as List)
          .map<Jewelry>((json) => Jewelry.fromJson(json))
          .toList();
    } catch (e) {
      print("Error loading jewelry data: $e");
    }
  }

  Future<List<Jewelry>> getAllJewelries() async {
    await loadAllJewelries();
    return allJewelries!.toList();
  }

  Future<bool> purchaseJewelry(Jewelry jewelry, BankAccount account) async {
    // Check if the account has enough funds
    if (account.balance < jewelry.value) {
      print("Insufficient funds to purchase this jewelry.");
      return false;
    }

    // Deduct the cost from the account
    account.withdraw(jewelry.value);
    print("Purchased ${jewelry.name} for \$${jewelry.value}");

    return true;
  }
}
