import 'package:bitlife_like/models/asset/arme.dart';
import 'package:bitlife_like/models/asset/assets.dart';
import 'package:bitlife_like/models/asset/book.dart';
import 'package:bitlife_like/models/asset/electronic.dart';
import 'package:bitlife_like/models/asset/instrument.dart';
import 'package:bitlife_like/models/asset/jewelry.dart';
import 'package:bitlife_like/models/asset/real_estate.dart';
import 'package:bitlife_like/models/asset/vehicle.dart';
import 'package:bitlife_like/models/inventory_item.dart';
import 'package:bitlife_like/models/marketplace.dart';

class ItemFactory {
  
  static InventoryItem? createItemFromType(String type) {
    switch (type) {
      case 'weapon':
        return Arme.random(); // ou un constructeur précis si besoin
      case 'vehicle':
        return Vehicle(id: 'veh_${DateTime.now().millisecondsSinceEpoch}', name: 'Voiture', price: 1000, skillEffects: {}, value: 1000);
      // autres cas
      default:
        return null;
    }
  }

  
  static InventoryItem fromMarketplace(MarketplaceItem item, String ownerId) {
    switch (item.category) {
      case MarketplaceCategory.weapons:
        return Arme(
          id: item.id,
          ownerId: ownerId,
          name: item.name,
          weaponType: "generic",
          damage: (item.skillEffects['firearms'] ?? 5).toInt(),
          value: item.price,
        );
      case MarketplaceCategory.vehicles:
        return Vehicle(
          id: item.id,
          ownerId: ownerId,
          name: item.name,
          brand: "Generic",
          model: "Model X",
          productionYear: DateTime.now().year,
          value: item.price,
        );
      case MarketplaceCategory.books:
        return Book(
          id: item.id,
          title: item.name,
          author: ownerId,
          skillEffects: item.skillEffects,
        );
      case MarketplaceCategory.electronics:
        return Electronic(
          id: item.id,
          ownerId: ownerId,
          name: item.name,
          value: item.price,
          age: 0,
          condition: AssetCondition.good,
          maintenanceCost: 10.0,
          brand: "Generic",
          typeElectronic: "smartphone",
        );
      case MarketplaceCategory.instruments:
        return Instrument(
          id: item.id,
          ownerId: ownerId,
          name: item.name,
          value: item.price,
          typeInstrument: "guitar",
        );
      case MarketplaceCategory.jewelry:
        return Jewelry(
          id: item.id,
          ownerId: ownerId,
          material: "or",
          carat: 18,
          name: item.name,
          value: item.price,
        );
      case MarketplaceCategory.realEstates:
        return RealEstate(
          id: item.id,
          ownerId: ownerId,
          location: "Inconnue",
          squareMeters: 50,
          rooms: 2,
          name: item.name,
          value: item.price,
        );
      default:
        throw Exception("Item non reconnu pour la fabrication");
    }
  }
}
