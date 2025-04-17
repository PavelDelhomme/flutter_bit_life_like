import 'package:bitlife_like/core/models/event.dart';

class EventDispatcher {
  final List<Function(Event)> _listeners = [];

  void dispatch(Event event) {
    for (var listener in _listeners) {
      listener(event);
    }
  }

  void subscribe(Function(Event) listener) {
    _listeners.add(listener);
  }

  void unsubscribe(Function(Event) listener) {
    _listeners.remove(listener);
  }
}