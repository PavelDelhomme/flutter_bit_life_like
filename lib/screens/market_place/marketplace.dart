import '../../Classes/objects/real_estate.dart';
import '../../Classes/objects/jewelry.dart';
import '../../Classes/objects/vehicles/avion.dart';
import '../../Classes/objects/vehicles/bateau.dart';
import '../../Classes/objects/vehicles/moto.dart';
import '../../Classes/objects/vehicles/voiture.dart';

class Marketplace<T> {
  List<T> availableItems = [];

  void addItemToMarket(T item) {
    availableItems.add(item);
  }

  T? buyItem(String itemName) {
    for (var item in availableItems) {
      if (item is Moto && item.name == itemName) {
        availableItems.remove(item);
        return item;
      } else if (item is Voiture && item.name == itemName) {
        availableItems.remove(item);
        return item;
      } else if (item is Bateau && item.name == itemName) {
        availableItems.remove(item);
        return item;
      } else if (item is Avion && item.name == itemName) {
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

  void addVehicleToMarket(T vehicle) {
    addItemToMarket(vehicle);
  }

  @override
  String toString() {
    return availableItems.map((item) => item.toString()).join('\n');
  }
}
