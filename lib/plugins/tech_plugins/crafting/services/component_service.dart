import 'dart:convert';
import 'dart:io';

import '../models/component.dart';

class ComponentService {
  static Future<List<Component>> loadComponents() async {
    final file = File('assets/components.json');
    final jsonString = await file.readAsString();
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((c) => Component(
      id: c['id'],
      name: c['name'],
      value: c['value'].toDouble(),
    )).toList();
  }
}
