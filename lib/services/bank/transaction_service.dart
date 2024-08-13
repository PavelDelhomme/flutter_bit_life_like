import 'package:bit_life_like/Classes/objects/antique.dart';
import 'package:bit_life_like/Classes/objects/arme.dart';
import 'package:bit_life_like/Classes/objects/collectible_item.dart';
import 'package:bit_life_like/Classes/objects/electronic.dart';
import 'package:bit_life_like/Classes/objects/instrument.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';
import 'package:bit_life_like/Classes/objects/vehicle_collection.dart';

import '../../Classes/person.dart';
import 'FinancialService.dart';
import 'bank_account.dart';

class TransactionService {
  Future<void> purchaseItem(BankAccount account, double price, Function onSuccess, Function onFailure) async {
    if (account.balance >= price) {
      account.withdraw(price);
      onSuccess();
    } else {
      onFailure("Insufficient funds.");
    }
  }

  Future<void> attemptPurchase(BankAccount account, CollectibleItem item, {bool useLoan = false, int loanTerm = 0, double loanInterestRate = 0.0, required Function onSuccess, required Function onFailure}) async {
    double price = item.value;
    if (useLoan) {
      bool loanApproved = await FinancialService.instance.applyForLoan(account, price, loanTerm, loanInterestRate);
      if (loanApproved) {
        account.withdraw(price);
        onSuccess();
      } else {
        onFailure("Loan was not approved.");
      }
    } else {
      if (account.balance >= price) {
        account.withdraw(price);
        onSuccess();
      } else {
        onFailure("Insufficient funds.");
      }
    }
  }

  Future<void> sellItem(Person person, CollectibleItem item, BankAccount account, double salePrice, Function onSuccess, Function onFailure) async {
    try {
      account.deposit(salePrice);
      person.collectibles.remove(item);
      //_removeItemFromPerson(person, item);
      onSuccess();
    } catch (e) {
      onFailure("Failed to sell item: ${e.toString()}");
    }
  }

  void _addItemToPerson(Person person, CollectibleItem item) {
    if (item is RealEstate) {
      person.realEstates.add(item);
    } else if (item is Vehicle) {
      person.vehicles.add(item);
    } else if (item is VehiculeExotique) {
      person.vehiculeExotiques.add(item);
    } else if (item is Jewelry) {
      person.jewelries.add(item);
    }
    else if (item is Electronic) {
      person.electronics.add(item);
    }
    else if (item is Antique) {
      person.antiques.add(item);
    }
    else if (item is Instrument) {
      person.instruments.add(item);
    }
    else if (item is Arme) {
      person.armes.add(item);
    } else {
      person.collectibles.add(item);
    }
  }

  void _removeItemFromPerson(Person person, CollectibleItem item) {
    if (item is RealEstate) {
      person.realEstates.remove(item);
    } else if (item is Vehicle) {
      person.vehicles.remove(item);
    } else if (item is VehiculeExotique) {
      person.vehiculeExotiques.remove(item);
    } else if (item is Jewelry) {
      person.jewelries.remove(item);
    } else if (item is Electronic) {
      person.electronics.remove(item);
    } else if (item is Antique) {
      person.antiques.remove(item);
    } else if (item is Instrument) {
      person.instruments.remove(item);
    } else if (item is CollectibleItem) {
      person.collectibles.remove(item);
    } else if (item is Arme) {
      person.armes.remove(item);
    }
  }
}
