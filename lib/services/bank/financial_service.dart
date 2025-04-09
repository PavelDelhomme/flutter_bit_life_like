import 'dart:math';
import '../../models/asset/antique.dart';
import '../../models/asset/real_estate.dart';
import '../../models/legal.dart';

import '../../models/economy/bank_account.dart' as models;
import '../../models/person/character.dart';
import '../../models/event.dart';
import '../data_service.dart';


class FinancialService {
  static final FinancialService _instance = FinancialService._internal();
  factory FinancialService() => _instance;
  FinancialService._internal();
  
  final Random _random = Random();
  
  // Taux d'inflation annuel (peut varier)
  double _inflationRate = 0.02; // 2% par défaut
  
  double get inflationRate => _inflationRate;
  
  // Traitement des finances annuelles
  void processYearlyFinances(Character character) {
    // Calculer les revenus
    double annualIncome = _calculateAnnualIncome(character);
    
    // Calculer les dépenses
    double annualExpenses = _calculateAnnualExpenses(character);
    
    // Gérer l'inflation
    _updateInflation();
    
    // Appliquer les intérêts bancaires
    _applyBankInterests(character);
    
    // Traiter les paiements des prêts
    _processLoanPayments(character);
    
    // Solde net annuel
    double netAmount = annualIncome - annualExpenses;
    
    // Appliquer au compte bancaire principal ou à l'argent liquide
    if (character.bankAccounts.isNotEmpty) {
      models.BankAccount mainAccount = character.bankAccounts.first;
      mainAccount.balance += netAmount;
      
      mainAccount.transactions.add(models.Transaction(
        amount: netAmount,
        date: DateTime.now(),
        type: models.TransactionType.deposit,
        description: "Revenu de $netAmount"
      ));
    } else {
      character.money += netAmount;
    }
    
    // Générer un événement financier annuel
    character.lifeEvents.add(Event(
      age: character.age,
      description: "Bilan financier: Revenus \$${annualIncome.toStringAsFixed(2)}, Dépenses \$${annualExpenses.toStringAsFixed(2)}",
      timestamp: DateTime.now(),
    ));
  }
  
  // Calcul des revenus annuels
  double _calculateAnnualIncome(Character character) {
    double total = 0.0;
    
    // Revenus professionnels
    if (character.career != null) {
      total += character.career!.calculateAnnualIncome();
    }
    
    // Revenus locatifs des propriétés
    for (var asset in character.assets) {
      if (asset is RealEstate && asset.isRented) {
        total += asset.monthlyRent * 12;
      }
    }
    
    // Intérêts des comptes bancaires (déjà gérés dans _applyBankInterests)
    
    return total;
  }
  
  // Calcul des dépenses annuelles
  double _calculateAnnualExpenses(Character character) {
    double total = 0.0;
    
    // Dépenses de maintenance pour les biens
    for (var asset in character.assets) {
      if (asset is RealEstate && asset.isRented) {
        total += asset.monthlyRent * 12;
      }
      if (asset is Antique && asset.isAuthenticated) {
        total += asset.value * 0.05; // Revenus d'exposition
      }
      total += asset.maintenanceCost * 12;
    }
    
    // Assurances
    for (var vehicle in character.vehicles) {
      if (vehicle.isInsured) {
        total += vehicle.insuranceCost * 12;
      }
    }
    
    // Impôts (simplifié)
    double taxRate = 0.2; // 20% d'impôts
    double taxableIncome = _calculateAnnualIncome(character);
    total += taxableIncome * taxRate;
    
    // Coût de la vie de base (nourriture, services, etc.)
    double basicLivingCost = 500 * 12; // $500 par mois
    total += basicLivingCost;
    
    return total;
  }
  
  // Mise à jour du taux d'inflation
  void _updateInflation() {
    // L'inflation varie aléatoirement entre -0.5% et +1.5% par rapport au taux actuel
    double change = (_random.nextDouble() * 2.0 - 0.5) / 100;
    _inflationRate += change;
    
    // Limites raisonnables pour l'inflation
    _inflationRate = _inflationRate.clamp(0.005, 0.15);
  }
  
  // Application des intérêts bancaires
  void _applyBankInterests(Character character) {
    for (var account in character.bankAccounts) {
      double interestAmount = account.balance * (account.interestRate / 100);
      
      if (interestAmount > 0) {
        account.balance += interestAmount;
        
        // Enregistrer la transaction
        account.transactions.add(models.Transaction(
          amount: interestAmount,
          description: "Intérêts annuels",
          date: DateTime.now(),
          type: models.TransactionType.interest
        ));
      }
      
      // Appliquer les frais mensuels annualisés
      if (account.monthlyFee > 0) {
        double annualFees = account.monthlyFee * 12;
        account.balance -= annualFees;
        
        account.transactions.add(models.Transaction(
          amount: -annualFees,
          description: "Frais annuels",
          date: DateTime.now(),
          type: models.TransactionType.fee
        ));
      }
    }
  }
  
  // Traitement des paiements de prêts
  void _processLoanPayments(Character character) {
    for (var account in character.bankAccounts) {
      for (var loan in account.loans) {
        if (loan.isDefaulted) continue;
        
        double annualPayment = loan.calculateMonthlyPayment() * 12;
        
        if (account.balance >= annualPayment) {
          // Paiement complet
          account.balance -= annualPayment;
          loan.remainingAmount -= annualPayment;
          
          account.transactions.add(models.Transaction(
            amount: -annualPayment,
            date: DateTime.now(),
            type: models.TransactionType.loanPayment,
            description: ''
          ));
          
          if (loan.remainingAmount <= 0) {
            loan.remainingAmount = 0;
            character.addLifeEvent("J'ai terminé de rembourser mon prêt: ${loan.purpose}");
          }
        } else {
          // Paiement partiel ou défaut
          double partialPayment = account.balance * 0.8; // Garder 20% comme tampon
          
          if (partialPayment > 0) {
            account.balance -= partialPayment;
            loan.remainingAmount -= partialPayment;
            
            account.transactions.add(models.Transaction(
              amount: -partialPayment,
              date: DateTime.now(),
              type: models.TransactionType.loanPayment,
              description: "Description"
            ));
          }
          
          // Augmenter le compteur de défauts
          loan.missed++;
          
          // Vérifier si le prêt est en défaut après 3 paiements manqués
          if (loan.missed >= 3) {
            loan.isDefaulted = true;
            character.addLifeEvent("Je suis en défaut de paiement pour mon prêt: ${loan.purpose}");
            
            // Impact sur le score de crédit
            character.creditScore -= 150;
            character.creditScore = character.creditScore.clamp(300.0, 850.0);
          }
        }
      }
    }
  }
  
  // Fonction pour calculer le pouvoir d'achat ajusté à l'inflation
  double adjustForInflation(double amount) {
    return amount * (1 + _inflationRate);
  }
  
  // Méthode pour effectuer un contrôle fiscal
  bool performFiscalControl(Character character) {
    // Probabilité de base d'être contrôlé
    double baseAuditProbability = 0.05; // 5%
    
    // Facteurs augmentant la probabilité
    double incomeDiscrepancy = character.actualIncome - character.declaredIncome;
    double discrepancyFactor = incomeDiscrepancy > 0 ? (incomeDiscrepancy / character.actualIncome) : 0;
    
    // Calcul de la probabilité finale
    double auditProbability = baseAuditProbability + (discrepancyFactor * 0.3);
    auditProbability = auditProbability.clamp(0.05, 0.8); // Entre 5% et 80%
    
    // Déterminer si un contrôle a lieu
    bool isAudited = _random.nextDouble() < auditProbability;
    
    if (isAudited) {
      // Vérifier si fraude détectée (si incomeDiscrepancy significative)
      bool fraudDetected = discrepancyFactor > 0.1; // Fraude si écart > 10%
      
      if (fraudDetected) {
        // Calculer l'amende
        double fine = incomeDiscrepancy * 1.5; // 150% du montant non déclaré
        
        // Appliquer l'amende
        if (character.bankAccounts.isNotEmpty) {
          character.bankAccounts.first.balance -= fine;
        } else {
          character.money -= fine;
        }
        
        character.addLifeEvent("Contrôle fiscal : fraude détectée avec une amende de \$${fine.toStringAsFixed(2)}");
        character.hasCriminalRecord = true;
        
        // Ajouter un crime fiscal
        Crime tax = Crime(
          id: 'crime_${DateTime.now().millisecondsSinceEpoch}',
          type: CrimeType.taxEvasion,
          date: DateTime.now(),
          description: "Fraude fiscale détectée lors d'un contrôle",
          punishment: PunishmentType.fine,
          fine: fine,
          isSolved: true,
        );
        
        character.criminalHistory.add(tax);
        
        return true;
      } else {
        character.addLifeEvent("Contrôle fiscal : aucune irrégularité détectée");
        return false;
      }
    }
    
    return false;
  }

  void applyTaxes(Character character) {
    final income = character.calculateTotalIncome();
    final taxRate = DataService.getTaxRateForCountry(character.country);
    final taxAmount = income * taxRate;

    character.money -= taxAmount;
    character.declaredIncome += income;

    character.addLifeEvent(
        'Paiement des impôts : \$${taxAmount.toStringAsFixed(2)} (${(taxRate * 100).toInt()}%)'
    );
  }
}
