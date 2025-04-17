import 'package:flutter/widgets.dart';

abstract class HasRoutes {
  Map<String, WidgetBuilder> getRoutes();
}