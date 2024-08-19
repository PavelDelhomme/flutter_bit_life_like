import 'package:bit_life_like/Classes/objects/antique.dart';
import 'package:bit_life_like/Classes/objects/arme.dart';
import '../../Classes/ficalite/evasion_fiscale.dart';
import '../../Classes/objects/art.dart';
import '../../Classes/objects/book.dart';
import '../../Classes/objects/electronic.dart';
import '../../Classes/objects/instrument.dart';
import '../../Classes/objects/jewelry.dart';
import '../../Classes/objects/real_estate.dart';
import '../../Classes/objects/vehicles/avion.dart';
import '../../Classes/objects/vehicles/bateau.dart';
import '../../Classes/objects/vehicles/moto.dart';
import '../../Classes/objects/vehicles/voiture.dart';
import '../../Classes/person.dart';
import 'FinancialService.dart';
import 'bank_account.dart';

class TransactionService {
  Future<void> purchaseItem(BankAccount account, double price, Function onSuccess, Function onFailure) async {
    if (account.balance >= price) {
      // Appliquez des conditions spécifiques pour les comptes offshore si nécessaire
      if (account is OffshoreAccount) {
        print("Processing transaction from offshore account in ${account.taxHavenCountry}");
      }
      account.withdraw(price);
      onSuccess();
    } else {
      onFailure("Insufficient funds.");
    }
  }


  Future<void> attemptPurchase(BankAccount account, dynamic item, {bool useLoan = false, int loanTerm = 0, double loanInterestRate = 0.0, required Function onSuccess, required Function onFailure}) async {
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

  Future<void> sellItem(Person person, dynamic item, BankAccount account, double salePrice, Function onSuccess, Function onFailure) async {
    try {
      account.deposit(salePrice);
      if (item is Antique) {
        person.antiques.remove(item);
      } else if (item is Arme){
        person.armes.remove(item);
      } else if (item is Art){
        person.arts.remove(item);
      } else if (item is Book){
        person.books.remove(item);
      } else if (item is Electronic){
        person.electronics.remove(item);
      } else if (item is Instrument){
        person.instruments.remove(item);
      } else if (item is Jewelry){
        person.jewelries.remove(item);
      } else if (item is RealEstate){
        person.realEstates.remove(item);
      } else if (item is Moto){
        person.motos.remove(item);
      } else if (item is Voiture){
        person.voitures.remove(item);
      } else if (item is Bateau){
        person.bateaux.remove(item);
      } else if (item is Avion){
        person.avions.remove(item);
      }
      //_removeItemFromPerson(person, item);
      onSuccess();
    } catch (e) {
      onFailure("Failed to sell item: ${e.toString()}");
    }
  }

}
