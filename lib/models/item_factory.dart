import 'package:bitlife_like/models/asset/arme.dart';
import 'package:bitlife_like/models/asset/assets.dart';
import 'package:bitlife_like/models/asset/book.dart';
import 'package:bitlife_like/models/asset/electronic.dart';
import 'package:bitlife_like/models/asset/instrument.dart';
import 'package:bitlife_like/models/asset/jewelry.dart';
import 'package:bitlife_like/models/asset/real_estate.dart';
import 'package:bitlife_like/models/asset/vehicle.dart';
import 'package:bitlife_like/models/crafting/component.dart';
import 'package:bitlife_like/models/inventory_item.dart';
import 'package:bitlife_like/models/marketplace.dart';
import 'package:uuid/uuid.dart';

class ItemFactory {
  final _uuid = Uuid();

  static InventoryItem? createItemFromType(String type) {
    final id = _uuid.v4();
    switch (type) {
      case 'weapon':
        return Arme(
          id: id,
          ownerId: 'crafting',
          name: "Arme artisanale",
          weaponType: "homemade",
          damage: 10,
          value: 500,
        );
      case 'vehicle':
        return Vehicle(
          id: id,
          ownerId: 'crafting',
          name: "Véhicule fabriqué",
          brand: "CustomBuild",
          model: "Proto",
          productionYear: DateTime.now().year,
          value: 3000,
        );
      case 'electronic':
        return Electronic(
          id: id,
          ownerId: 'crafting',
          name: "Smart Gadget",
          value: 800,
          age: 0,
          condition: AssetCondition.excellent,
          maintenanceCost: 10,
          brand: "MakerTech",
          typeElectronic: "homemade",
        );
      case 'instrument':
        return Instrument(
          id: id,
          ownerId: 'crafting',
          name: "Instrument artisanal",
          typeInstrument: "guitar",
          value: 600,
        );
      case 'jewelry':
        return Jewelry(
          id: id,
          ownerId: 'crafting',
          name: "Bijou artisanal",
          material: "argent",
          carat: 14,
          value: 350,
        );
      case 'realEstate':
        return RealEstate(
          id: id,
          ownerId: 'crafting',
          location: "Auto-construction",
          squareMeters: 50,
          rooms: 3,
          name: "Petite maison",
          value: 10000,
        );
      case 'component':
        return CraftingComponent(
          id: id,
          name: "Composant universel",
          value: 100,
        );
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
      case MarketplaceCategory.components:
        return CraftingComponent(
            id: item.id,
            name: item.name,
            value: item.price,
        );
      default:
        throw Exception("Item non reconnu pour la fabrication");
    }
  }
}
