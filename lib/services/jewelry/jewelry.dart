import 'dart:convert';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/jewelry.dart';
import '../bank/bank_account.dart';

class JewelryService {
  List<Jewelry>? allJewelries;

  Future<void> loadAllJewelries() async {
    if (allJewelries != null) return;
    try {
      String jewelryJson = await rootBundle.loadString('assets/jewelry.json');
      var decodedJson = json.decode(jewelryJson);
      allJewelries = (decodedJson['jewelry'] as List)
          .map<Jewelry>((json) => Jewelry.fromJson(json))
          .toList();
    } catch (e) {
      print("Error loading jewelry data: $e");
    }
  }

  Future<List<Jewelry>> getJewelriesByBrandAndMaterial(
      String brand, String material) async {
    await loadAllJewelries();
    return allJewelries!.where((jewelry) {
      bool brandMatches = (brand == "All" || jewelry.brand == brand);
      bool materialMatches = (material == "All" || jewelry.material == material);
      return brandMatches && materialMatches;
    }).toList();
  }

  Future<List<Jewelry>> getAllJewelries() async {
    await loadAllJewelries();
    return allJewelries!.toList();
  }

  Future<bool> purchaseJewelry(Jewelry jewelry, BankAccount account) async {
    if (account.balance < jewelry.value) {
      print("Insufficient funds to purchase this jewelry.");
      return false;
    }

    account.withdraw(jewelry.value);
    print("Purchased ${jewelry.name} for \$${jewelry.value}");

    return true;
  }

  double calculateSalePrice(Jewelry jewelry) {
    double depreciationFactor = 1 - (100 - jewelry.condition) * 0.01;
    return jewelry.value * depreciationFactor;
  }

  Future<void> sellJewelry(Jewelry jewelry, BankAccount account, Person person, TransactionService transactionService) async {
    double salePrice = calculateSalePrice(jewelry);

    await transactionService.sellItem(
      person,
      jewelry,
      account,
      salePrice,
        () {
        print("Sold ${jewelry.name} for \$${salePrice.toStringAsFixed(2)}");
        person.jewelries.remove(jewelry);
        },
        (error) {
        print("Failed to sell ${jewelry.name}: $error");
        },
    );
  }
}
