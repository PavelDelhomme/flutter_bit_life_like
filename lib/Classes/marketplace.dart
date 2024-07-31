import 'vehicle.dart';
import 'real_estate.dart';
import 'jewelry.dart';

class Marketplace<T> {
  List<T> availableItems = [];

  void addItemToMarket(T item) {
    availableItems.add(item);
  }

  T? buyItem(String itemName) {
    for (var item in availableItems) {
      if (item is Vehicle && item.name == itemName) {
        availableItems.remove(item);
        return item;
      } else if (item is RealEstate && item.name == itemName) {
        availableItems.remove(item);
        return item;
      } else if (item is Jewelry && item.name == itemName) {
        availableItems.remove(item);
        return item;
      }
    }
    return null;
  }

  void addVehicleToMarket(Vehicle vehicle) {
    addItemToMarket(vehicle as T);
  }

  @override
  String toString() {
    return availableItems.map((item) => item.toString()).join('\n');
  }
}
