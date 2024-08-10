import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/electronic.dart';
import '../bank/bank_account.dart';

class ElectronicService {
  List<Electronic>? allElectronics;

  Future<void> loadAllElectronics() async {
    if (allElectronics != null) return;
    try {
      String jsonString = await rootBundle.loadString('assets/electronics.json');
      var decoded = json.decode(jsonString);
      allElectronics = (decoded['electronics'] as List)
          .map<Electronic>((json) => Electronic.fromJson(json))
          .toList();
    } catch (e) {
      print("Error loading electronic data: $e");
    }
  }

  Future<List<Electronic>> getAllElectronics() async {
    await loadAllElectronics();
    return allElectronics!.toList();
  }

  Future<bool> purchaseElectronic(Electronic electronic, BankAccount account) async {
    // Check if the account has enough funds
    if (account.balance < electronic.value) {
      print("Insufficient funds to purchase this electronic.");
      return false;
    }

    // Deduct the cost from the account
    account.withdraw(electronic.value);
    print("Purchased ${electronic.model} for \$${electronic.value}");

    return true;
  }
}
