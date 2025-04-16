import 'dart:convert';
import 'dart:io';

import 'package:bitlife_like/models/crafting/component.dart';

class ComponentService {
  static Future<List<CraftingComponent>> loadComponents() async {
    final file = File('assets/components.json');
    final jsonString = await file.readAsString();
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((c) => CraftingComponent(
      id: c['id'],
      name: c['name'],
      value: c['value'].toDouble(),
    )).toList();
  }
}
