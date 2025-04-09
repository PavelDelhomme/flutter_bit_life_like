import 'dart:math';

import '../models/person/character.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/economy/bank_account.dart';
import '../models/economy/loan.dart';

class BankingScreen extends StatefulWidget {
  final Character character;
  
  const BankingScreen({Key? key, required this.character}) : super(key: key);
  
  @override
  _BankingScreenState createState() => _BankingScreenState();
}

class _BankingScreenState extends State<BankingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Système Bancaire'),
        backgroundColor: const Color(0xFF0D47A1),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Comptes'),
            Tab(text: 'Transactions'),
            Tab(text: 'Prêts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAccountsTab(),
          _buildTransactionsTab(),
          _buildLoansTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAccountOptions,
      ),
    );
  }
  
  Widget _buildAccountsTab() {
    if (widget.character.bankAccounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Aucun compte bancaire',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showAccountOptions,
              child: const Text('Ouvrir un compte'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: widget.character.bankAccounts.length,
      itemBuilder: (context, index) {
        final account = widget.character.bankAccounts[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      account.bankName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getAccountColor(account.accountType),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getAccountTypeLabel(account.accountType),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('N° de compte: ${account.accountNumber}'),
                const SizedBox(height: 8),
                Text(
                  'Solde: \$${account.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Taux d\'intérêt: ${account.interestRate}%'),
                if (account.monthlyFee > 0)
                  Text('Frais mensuels: \$${account.monthlyFee.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Dépôt'),
                      onPressed: () => _showDepositDialog(account),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.remove),
                      label: const Text('Retrait'),
                      onPressed: () => _showWithdrawDialog(account),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Transfert'),
                      onPressed: () => _showTransferDialog(account),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTransactionsTab() {
    // Fusionner toutes les transactions de tous les comptes
    List<Transaction> allTransactions = [];
    for (var account in widget.character.bankAccounts) {
      allTransactions.addAll(account.transactions);
    }
    
    // Trier par date (plus récente en premier)
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    
    if (allTransactions.isEmpty) {
      return const Center(
        child: Text('Aucune transaction effectuée'),
      );
    }
    
    return ListView.builder(
      itemCount: allTransactions.length,
      itemBuilder: (context, index) {
        final transaction = allTransactions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getTransactionColor(transaction.type),
            child: Icon(_getTransactionIcon(transaction.type), color: Colors.white),
          ),
          title: Text(transaction.description),
          subtitle: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
          ),
          trailing: Text(
            '${transaction.amount >= 0 ? '+' : ''}\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.amount >= 0 ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildLoansTab() {
    // Fusionner tous les prêts de tous les comptes
    List<Loan> allLoans = [];
    for (var account in widget.character.bankAccounts) {
      allLoans.addAll(account.loans);
    }
    
    if (allLoans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.money_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Aucun prêt en cours',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showLoanOptions,
              child: const Text('Demander un prêt'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: allLoans.length,
      itemBuilder: (context, index) {
        final loan = allLoans[index];
        // Calculer le pourcentage remboursé
        double repaidPercentage = 1 - (loan.remainingAmount / loan.amount);
        
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prêt: ${loan.purpose}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: loan.isDefaulted ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        loan.isDefaulted ? 'Défaut' : 'Actif',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Montant initial: \$${loan.amount.toStringAsFixed(2)}'),
                Text('Restant: \$${loan.remainingAmount.toStringAsFixed(2)}'),
                Text('Taux d\'intérêt: ${loan.interestRate}%'),
                Text('Durée: ${loan.termYears} ans'),
                Text('Paiement mensuel: \$${loan.calculateMonthlyPayment().toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Progression du remboursement:'),
                LinearProgressIndicator(
                  value: repaidPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loan.isDefaulted ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showRepayLoanDialog(loan),
                    child: const Text('Effectuer un remboursement'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Utilitaires
  Color _getAccountColor(AccountType type) {
    switch (type) {
      case AccountType.checking: return Colors.blue;
      case AccountType.savings: return Colors.green;
      case AccountType.investment: return Colors.purple;
      case AccountType.retirement: return Colors.orange;
      case AccountType.business: return Colors.brown;
      case AccountType.joint: return Colors.teal;
      default: return Colors.grey;
    }
  }
  
  String _getAccountTypeLabel(AccountType type) {
    switch (type) {
      case AccountType.checking: return 'Courant';
      case AccountType.savings: return 'Épargne';
      case AccountType.investment: return 'Investissement';
      case AccountType.retirement: return 'Retraite';
      case AccountType.business: return 'Professionnel';
      case AccountType.joint: return 'Joint';
      default: return 'Autre';
    }
  }
  
  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.deposit: return Colors.green;
      case TransactionType.withdrawal: return Colors.red;
      case TransactionType.transfer: return Colors.blue;
      case TransactionType.interest: return Colors.teal;
      case TransactionType.loan: return Colors.purple;
      case TransactionType.loanPayment: return Colors.indigo;
      case TransactionType.fee: return Colors.orange;
      case TransactionType.tax: return Colors.brown;
      case TransactionType.missed: return Colors.deepOrange;
      default: return Colors.grey;
    }
  }
  
  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit: return Icons.arrow_upward;
      case TransactionType.withdrawal: return Icons.arrow_downward;
      case TransactionType.transfer: return Icons.swap_horiz;
      case TransactionType.interest: return Icons.monetization_on;
      case TransactionType.loan: return Icons.request_quote;
      case TransactionType.loanPayment: return Icons.payments;
      case TransactionType.fee: return Icons.money_off;
      case TransactionType.tax: return Icons.account_balance;
      case TransactionType.missed: return Icons.warning;
      default: return Icons.receipt;
    }
  }
  
  void _showAccountOptions() {
    // if (widget.character.age < 16) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Vous devez avoir au moins 16 ans pour ouvrir un compte bancaire'))
    //   );
    //   return;
    // }
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.account_balance, color: _getAccountColor(AccountType.checking)),
                title: const Text('Compte courant'),
                subtitle: const Text('Pour vos transactions quotidiennes'),
                onTap: () {
                  Navigator.pop(context);
                  _openAccount(AccountType.checking);
                },
              ),
              ListTile(
                leading: Icon(Icons.savings, color: _getAccountColor(AccountType.savings)),
                title: const Text('Compte épargne'),
                subtitle: const Text('Intérêts plus élevés pour votre argent'),
                onTap: () {
                  Navigator.pop(context);
                  _openAccount(AccountType.savings);
                },
              ),
              ListTile(
                leading: Icon(Icons.trending_up, color: _getAccountColor(AccountType.investment)),
                title: const Text('Compte d\'investissement'),
                subtitle: const Text('Pour acheter des actions et diversifier'),
                onTap: () {
                  Navigator.pop(context);
                  _openAccount(AccountType.investment);
                },
              ),
              if (widget.character.age >= 18)
                ListTile(
                  leading: Icon(Icons.business, color: _getAccountColor(AccountType.business)),
                  title: const Text('Compte professionnel'),
                  subtitle: const Text('Pour gérer votre entreprise'),
                  onTap: () {
                    Navigator.pop(context);
                    _openAccount(AccountType.business);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  
  void _openAccount(AccountType accountType) {
    // Liste des banques disponibles
    List<String> availableBanks = ['BNP Paribas', 'Crédit Agricole', 'Société Générale', 'Caisse d\'Épargne'];
    
    // Taux d'intérêt selon le type de compte
    Map<AccountType, double> interestRates = {
      AccountType.checking: 0.1,
      AccountType.savings: 2.0,
      AccountType.investment: 4.0,
      AccountType.business: 0.5,
    };
    
    String bankName = availableBanks[Random().nextInt(availableBanks.length)];
    double interestRate = interestRates[accountType] ?? 0.1;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double initialDeposit = 100.0;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Ouvrir un compte ${_getAccountTypeLabel(accountType)}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Banque: $bankName'),
                  Text('Taux d\'intérêt: $interestRate%'),
                  const SizedBox(height: 16),
                  const Text('Dépôt initial:'),
                  Slider(
                    value: initialDeposit,
                    min: 100,
                    max: widget.character.money,
                    divisions: 100,
                    label: '\$${initialDeposit.toStringAsFixed(0)}',
                    onChanged: (double value) {
                      setState(() {
                        initialDeposit = value;
                      });
                    },
                  ),
                  Text('\$${initialDeposit.toStringAsFixed(2)}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text('Ouvrir le compte'),
                  onPressed: () {
                    Navigator.pop(context);
                    
                    // Créer un nouveau compte
                    final newAccount = BankAccount(
                      id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
                      accountNumber: 'ACC${Random().nextInt(900000) + 100000}',
                      bankName: bankName,
                      accountType: accountType,
                      balance: initialDeposit,
                      interestRate: interestRate,
                      accountHolders: [widget.character.id],
                    );
                    
                    // Débiter l'argent du joueur
                    widget.character.money -= initialDeposit;
                    
                    // Ajouter une transaction initiale
                    newAccount.transactions.add(Transaction(
                      amount: initialDeposit,
                      description: 'Dépôt initial',
                      date: DateTime.now(),
                      type: TransactionType.deposit,
                    ));
                    
                    // Ajouter le compte à la liste des comptes
                    setState(() {
                      widget.character.bankAccounts.add(newAccount);
                    });
                    
                    // Ajouter un événement
                    widget.character.addLifeEvent(
                      "J'ai ouvert un compte ${_getAccountTypeLabel(accountType)} à $bankName avec un dépôt initial de \$${initialDeposit.toStringAsFixed(2)}"
                    );
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compte ouvert avec succès !'))
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showDepositDialog(BankAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double amount = 100.0;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Effectuer un dépôt'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Solde actuel: \$${widget.character.money.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  const Text('Montant à déposer:'),
                  Slider(
                    value: amount,
                    min: 10,
                    max: widget.character.money,
                    divisions: 100,
                    label: '\$${amount.toStringAsFixed(0)}',
                    onChanged: (double value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
                  Text('\$${amount.toStringAsFixed(2)}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text('Déposer'),
                  onPressed: () {
                    Navigator.pop(context);
                    
                    // Débiter l'argent du joueur
                    widget.character.money -= amount;
                    
                    // Créditer le compte
                    account.deposit(amount, 'Dépôt en espèces');
                    
                    // Mettre à jour l'interface
                    setState(() {});
                    
                    widget.character.addLifeEvent(
                      "J'ai déposé \$${amount.toStringAsFixed(2)} sur mon compte ${account.accountNumber}"
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showWithdrawDialog(BankAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double amount = min(100.0, account.balance);
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Effectuer un retrait'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Solde du compte: \$${account.balance.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  const Text('Montant à retirer:'),
                  Slider(
                    value: amount,
                    min: 10,
                    max: account.balance,
                    divisions: 100,
                    label: '\$${amount.toStringAsFixed(0)}',
                    onChanged: (double value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
                  Text('\$${amount.toStringAsFixed(2)}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text('Retirer'),
                  onPressed: () {
                    Navigator.pop(context);
                    
                    // Retirer l'argent du compte
                    bool success = account.withdraw(amount, 'Retrait en espèces');
                    
                    if (success) {
                      // Créditer l'argent au joueur
                      widget.character.money += amount;
                      
                      // Mettre à jour l'interface
                      setState(() {});
                      
                      widget.character.addLifeEvent(
                        "J'ai retiré \$${amount.toStringAsFixed(2)} de mon compte ${account.accountNumber}"
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showTransferDialog(BankAccount sourceAccount) {
    if (widget.character.bankAccounts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez avoir au moins deux comptes pour effectuer un transfert'))
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double amount = min(100.0, sourceAccount.balance);
        BankAccount? targetAccount = widget.character.bankAccounts
            .firstWhere((a) => a.id != sourceAccount.id);
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Effectuer un transfert'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Solde du compte source: \$${sourceAccount.balance.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  DropdownButton<BankAccount>(
                    isExpanded: true,
                    value: targetAccount,
                    hint: const Text('Compte destinataire'),
                    items: widget.character.bankAccounts
                        .where((a) => a.id != sourceAccount.id)
                        .map((BankAccount account) {
                      return DropdownMenuItem<BankAccount>(
                        value: account,
                        child: Text('${account.bankName} - ${_getAccountTypeLabel(account.accountType)}'),
                      );
                    }).toList(),
                    onChanged: (BankAccount? newValue) {
                      setState(() {
                        targetAccount = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Montant à transférer:'),
                  Slider(
                    value: amount,
                    min: 10,
                    max: sourceAccount.balance,
                    divisions: 100,
                    label: '\$${amount.toStringAsFixed(0)}',
                    onChanged: (double value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
                  Text('\$${amount.toStringAsFixed(2)}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text('Transférer'),
                  onPressed: () {
                    if (targetAccount == null) return;
                    
                    Navigator.pop(context);
                    
                    // Effectuer le transfert
                    bool success = sourceAccount.transfer(
                      targetAccount!,
                      amount,
                      'Transfert entre comptes'
                    );
                    
                    if (success) {
                      // Mettre à jour l'interface
                      setState(() {});
                      
                      widget.character.addLifeEvent(
                        "J'ai transféré \$${amount.toStringAsFixed(2)} de mon compte ${sourceAccount.accountNumber} vers ${targetAccount!.accountNumber}"
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showLoanOptions() {
    if (widget.character.bankAccounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez avoir un compte bancaire pour demander un prêt'))
      );
      return;
    }
    
    if (widget.character.age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être majeur pour demander un prêt'))
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.home, color: Colors.brown),
                title: const Text('Prêt immobilier'),
                subtitle: const Text('Pour acheter une propriété'),
                onTap: () {
                  Navigator.pop(context);
                  _applyForLoan('Prêt immobilier');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.blue),
                title: const Text('Prêt automobile'),
                subtitle: const Text('Pour acheter un véhicule'),
                onTap: () {
                  Navigator.pop(context);
                  _applyForLoan('Prêt automobile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.purple),
                title: const Text('Prêt étudiant'),
                subtitle: const Text('Pour financer vos études'),
                onTap: () {
                  Navigator.pop(context);
                  _applyForLoan('Prêt étudiant');
                },
              ),
              ListTile(
                leading: const Icon(Icons.business, color: Colors.green),
                title: const Text('Prêt professionnel'),
                subtitle: const Text('Pour développer votre activité'),
                onTap: () {
                  Navigator.pop(context);
                  _applyForLoan('Prêt professionnel');
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _applyForLoan(String purpose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double amount = 10000.0;
        int years = 5;
        BankAccount? selectedAccount = widget.character.bankAccounts.first;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Calcul du paiement mensuel estimé
            double rate = selectedAccount!.interestRate / 100 / 12;
            int payments = years * 12;
            double monthlyPayment = amount * (rate * pow(1 + rate, payments)) / (pow(1 + rate, payments) - 1);
            
            return AlertDialog(
              title: Text('Demander un $purpose'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<BankAccount>(
                    isExpanded: true,
                    value: selectedAccount,
                    hint: const Text('Compte à créditer'),
                    items: widget.character.bankAccounts.map((BankAccount account) {
                      return DropdownMenuItem<BankAccount>(
                        value: account,
                        child: Text('${account.bankName} - ${_getAccountTypeLabel(account.accountType)}'),
                      );
                    }).toList(),
                    onChanged: (BankAccount? newValue) {
                      setDialogState(() {
                        selectedAccount = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Montant du prêt:'),
                  Slider(
                    value: amount,
                    min: 1000,
                    max: 100000,
                    divisions: 99,
                    label: '\$${amount.toStringAsFixed(0)}',
                    onChanged: (double value) {
                      setDialogState(() {
                        amount = value;
                      });
                    },
                  ),
                  Text('\$${amount.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  const Text('Durée du prêt (années):'),
                  Slider(
                    value: years.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$years an${years > 1 ? 's' : ''}',
                    onChanged: (double value) {
                      setDialogState(() {
                        years = value.toInt();
                      });
                    },
                  ),
                  Text('$years an${years > 1 ? 's' : ''}'),
                  const SizedBox(height: 16),
                  Text('Paiement mensuel estimé: \$${monthlyPayment.toStringAsFixed(2)}'),
                  Text('Taux d\'intérêt: ${selectedAccount?.interestRate}%'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text('Demander le prêt'),
                  onPressed: () {
                    Navigator.pop(context);
                    
                    // Demander le prêt
                    Loan? loan = selectedAccount?.applyForLoan(amount, years, purpose);
                    
                    if (loan != null) {
                      // Prêt approuvé
                      setState(() {});
                      
                      widget.character.addLifeEvent(
                        "J'ai obtenu un $purpose de \$${amount.toStringAsFixed(2)} sur $years ans auprès de ${selectedAccount?.bankName}"
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Prêt de \$${amount.toStringAsFixed(2)} approuvé !'))
                      );
                    } else {
                      // Prêt refusé
                      widget.character.addLifeEvent(
                        "Ma demande de $purpose de \$${amount.toStringAsFixed(2)} a été refusée par ${selectedAccount?.bankName}"
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Prêt refusé. Vérifiez vos revenus ou votre historique de crédit.'))
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showRepayLoanDialog(Loan loan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double amount = loan.calculateMonthlyPayment();
        return AlertDialog(
          title: Text('Rembourser le prêt ${loan.purpose}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Montant du remboursement: \$${amount.toStringAsFixed(2)}'),
              Text('Solde restant: \$${loan.remainingAmount.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Logique de remboursement
              },
              child: const Text('Payer'),
            ),
          ],
        );
      },
    );
  }
}