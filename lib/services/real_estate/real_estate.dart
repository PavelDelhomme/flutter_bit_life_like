import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/real_estate.dart';

class RealEstateService {
  Future<List<RealEstate>> getAvailableRealEstate() async {
    String jsonString = await rootBundle.loadString('assets/real_estate.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> realEstates = jsonResponse['real_estate'];
    return realEstates.map<RealEstate>((json) => RealEstate.fromJson(json)).toList();
  }

  Future<List<RealEstate>> getAvailableExoticRealEstate() async {
    String jsonString = await rootBundle.loadString('assets/real_estate_exotic.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> realEstates = jsonResponse['real_estate_exotique'];
    return realEstates.map<RealEstate>((json) => RealEstate.fromJson(json)).toList();
  }
}
