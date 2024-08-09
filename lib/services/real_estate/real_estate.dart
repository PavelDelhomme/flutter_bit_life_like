import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/real_estate.dart';
import '../bank/bank_account.dart';

class RealEstateService {
  List<RealEstate>? allRealEstates;

  Future<void> loadAllRealEstates() async {
    if (allRealEstates != null) return;
    try {
      String classicJson = await rootBundle.loadString('assets/real_estate.json');
      var decodedClassic = json.decode(classicJson);
      List<RealEstate> classicEstates = (decodedClassic['real_estate'] as List)
          .map<RealEstate>((json) => RealEstate.fromJson(json)).toList();

      String exoticJson = await rootBundle.loadString('assets/real_estate_exotic.json');
      var decodedExotic = json.decode(exoticJson);
      List<RealEstate> exoticEstates = (decodedExotic['real_estate_exotique'] as List)
          .map<RealEstate>((json) => RealEstate.fromJson(json)).toList();

      allRealEstates = [...classicEstates, ...exoticEstates];
    } catch (e) {
      print("Error loading real estate data: $e");
    }
  }

  Future<List<RealEstate>> getPropertiesByTypeAndStyle(String type, String style) async {
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
    realEstate.estLouee = true; // Mark as sold or rented
    print("Purchased ${realEstate.name} for \$${realEstate.value}");

    return true;
  }
}
