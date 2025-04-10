import '../../models/asset/assets.dart';
import '../../models/economy/bank_account.dart';
import '../../models/economy/fiscality.dart';
import '../../models/economy/loan.dart';
import '../../models/legal.dart';
import '../../models/marketplace.dart';
import '../../models/person/character.dart';

class TransactionService {
  static void purchaseItem({
    required MarketplaceItem item,
    required Character buyer,
    required BankAccount account,
    double downPayment = 0.3,
  }) {
    final taxSystem = buyer.legalSystem?.taxSystem ?? TaxSystem(country: buyer.country);

    // Calcul des taxes
    final tax = taxSystem.calculateVAT(item.price);
    final totalCost = item.price + tax;

    if (account.balance >= totalCost * downPayment) {
      // Achat comptant
      _processCashPurchase(item, buyer, account, totalCost);
    } else {
      // Demande de prêt
      final loan = _applyForLoan(account, totalCost, buyer);
      if (loan != null) {
        _processLoanPurchase(item, buyer, account, loan, totalCost);
      }
    }

    // Application des effets de l'item
    item.skillEffects.forEach((skillId, exp) {
      buyer.improveSkill(skillId, exp);
    });
  }

  static void _processCashPurchase(MarketplaceItem item, Character buyer, BankAccount account, double totalCost) {
    account.withdraw(totalCost, "Achat de ${item.name}");
    buyer.inventory.add(item);
    buyer.addLifeEvent("Achat de ${item.name} pour \$${totalCost.toStringAsFixed(2)}");
  }

  static Loan? _applyForLoan(BankAccount account, double amount, Character buyer) {
    return account.applyForLoan(
      amount,
      5, // 5 ans
      "Achat de ${buyer.inventory.last.name}",
    );
  }

  static void _processLoanPurchase(MarketplaceItem item, Character buyer, BankAccount account, Loan loan, double totalCost) {
    account.deposit(loan.amount, "Prêt pour achat");
    account.withdraw(totalCost, "Achat à crédit de ${item.name}");
    buyer.inventory.add(item);
    buyer.addLifeEvent("Achat à crédit de ${item.name} (Prêt: \$${loan.amount.toStringAsFixed(2)})");
  }

  static void transferAsset(Asset asset, Character from, Character to, TaxSystem taxSystem) {
    final transferTax = taxSystem.calculateTransferTax(asset.value);

    if (from.money >= transferTax) {
      from.money -= transferTax;
      asset.transferOwnership(to.id);
      from.assets.remove(asset);
      to.assets.add(asset);
    }
  }

  static void transferBetweenAccounts({
    required BankAccount from,
    required BankAccount to,
    required double amount,
    required TaxSystem tax,
  }) {
    final transferTax = amount * tax.transferTaxRate;

    if (from.withdraw(amount + transferTax, 'Tranfer to ${to.accountNumber}')) {
      to.deposit(amount, 'Transfert from ${from.accountNumber}');
    }
  }

}
