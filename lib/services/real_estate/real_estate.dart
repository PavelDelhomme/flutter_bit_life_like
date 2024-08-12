import 'dart:convert';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/real_estate.dart';
import '../bank/bank_account.dart';

class RealEstateService {
  List<RealEstate>? allRealEstates;

  Future<void> loadAllRealEstates() async {
    if (allRealEstates != null) return;
    try {
      String classicJson =
          await rootBundle.loadString('assets/real_estate.json');
      var decodedClassic = json.decode(classicJson);
      List<RealEstate> classicEstates = (decodedClassic['real_estate'] as List)
          .map<RealEstate>((json) => RealEstate.fromJson(json))
          .toList();

      String exoticJson =
          await rootBundle.loadString('assets/real_estate_exotic.json');
      var decodedExotic = json.decode(exoticJson);
      List<RealEstate> exoticEstates =
          (decodedExotic['real_estate_exotique'] as List)
              .map<RealEstate>((json) => RealEstate.fromJson(json))
              .toList();

      allRealEstates = [...classicEstates, ...exoticEstates];
    } catch (e) {
      print("Error loading real estate data: $e");
    }
  }

  Future<List<RealEstate>> getPropertiesByTypeAndStyle(
      String type, String style) async {
    await loadAllRealEstates();
    return allRealEstates!.where((estate) {
      bool typeMatches = (type == "All" || estate.type == type);
      bool styleMatches = (style == "All" || estate.style == style);
      return typeMatches && styleMatches;
    }).toList();
  }

  Future<List<RealEstate>> getAllPropertiesWithoutTypeAndStyle() async {
    await loadAllRealEstates();
    return allRealEstates!.toList();
  }

  Future<bool> purchaseRealEstate(
      RealEstate realEstate, BankAccount account) async {
    // Check if the estate is exotic and already sold
    if (realEstate.isExotic && realEstate.estLouee) {
      print("This exotic real estate is not available for purchase.");
      return false;
    }

    // Check if the account has enough funds
    if (account.balance < realEstate.value) {
      print("Insufficient funds to purchase this property.");
      return false;
    }

    // Deduct the cost from the account
    account.withdraw(realEstate.value);
    print("Purchased ${realEstate.name} for \$${realEstate.value}");

    return true;
  }

  double calculateSalePrice(RealEstate estate) {
    double depreciationFactor =
        1 - (estate.age * 0.02) - ((100 - estate.condition) * 0.01);
    return estate.value * depreciationFactor;
  }

  Future<void> sellRealEstate(RealEstate estate, BankAccount account, Person person, TransactionService transactionService) async {
    if (!estate.estLouee) {
      print("This property is not available for sale.");
      return;
    }

    double salePrice = calculateSalePrice(estate);

    await transactionService.sellItem(
      person,
      estate,
      account,
      salePrice,
          () {
        print("Sold ${estate.name} for \$${salePrice.toStringAsFixed(2)}");
      },
          (error) {
        print("Failed to sell ${estate.name}: $error");
      },
    );
  }
}
