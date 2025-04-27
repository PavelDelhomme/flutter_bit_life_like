import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/component.dart';

class ComponentService {
  static Future<List<Component>> loadComponents() async {
    final jsonString = await rootBundle.loadString("assets/data/crafting/components.json");
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((c) => Component(
      id: c['id'],
      name: c['name'],
      value: c['value'].toDouble(),
    )).toList();
  }
}
