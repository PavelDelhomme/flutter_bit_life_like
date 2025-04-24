import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/arme.dart';
import 'package:bitlife_like/plugins/core_plugins/book_system/models/book.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/electronic.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/instrument.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/jewelry.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/real_estate.dart';
import 'package:bitlife_like/plugins/core_plugins/assets_extended/models/vehicle.dart';
import 'package:bitlife_like/core/shared/inventory_item.dart';
import 'package:bitlife_like/plugins/tech_plugins/crafting/models/component.dart';
import 'package:uuid/uuid.dart';

import 'package:bitlife_like/plugins/tech_plugins/marketplace_system/models/marketplace_enum.dart';
import 'package:bitlife_like/core/models/asset.dart';

import '../../plugins/tech_plugins/marketplace_system/models/marketplace_item.dart';

class ItemFactory {
  static final _uuid = Uuid(); // <- ça corrige l'erreur

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
        return Component(
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
        return Component(
          id: item.id,
          name: item.name,
          value: item.price,
        );
      default:
        throw Exception("Item non reconnu pour la fabrication");
    }
  }
}
