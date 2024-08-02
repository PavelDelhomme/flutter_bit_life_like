import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../Classes/objects/real_estate.dart';

class RealEstateService {
  Future<List<RealEstate>> getAvailableRealEstate() async {
    return _loadRealEstate();
  }

  Future<List<RealEstate>> getPropertiesByType(String type) async {
    List<RealEstate> allEstates = await _loadRealEstate();
    return allEstates.where((estate) => estate.type == type).toList();
  }

  Future<List<RealEstate>> _loadRealEstate() async {
    String jsonString = await rootBundle.loadString('lib/files/real_estate.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    List<dynamic> jsonList = jsonMap['real_estate'];
    return jsonList.map((jsonItem) => RealEstate.fromJson(jsonItem)).toList();
  }
}
