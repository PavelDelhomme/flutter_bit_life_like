import 'package:bit_life_like/Classes/life_history_event.dart';
import 'package:bit_life_like/services/life_history.dart';
import 'package:flutter/material.dart';
import '../../../../../../../Classes/objects/real_estate.dart';
import '../../../../../../../Classes/person.dart';
import '../../../../../../../services/bank/bank_account.dart';
import '../../../../../../../services/bank/transaction_service.dart';
import '../../../../../../../services/real_estate/real_estate.dart';

class RealEstateExoticScreen extends StatefulWidget {
  final RealEstateService realEstateService;
  final TransactionService transactionService;
  final Person person;

  RealEstateExoticScreen({
    required this.realEstateService,
    required this.transactionService,
    required this.person,
  });

  @override
  _RealEstateExoticScreenState createState() => _RealEstateExoticScreenState();
}

class _RealEstateExoticScreenState extends State<RealEstateExoticScreen> {
  String selectedType = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exotic Real Estate Market'),
        actions: <Widget>[
          DropdownButton<String>(
            value: selectedType,
            icon: Icon(Icons.arrow_downward),
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            items: <String>[
              "All",
              "Résidence Privée",
              "Villa",
              "Manoir",
              "Estate",
              "Ski Lodge",
              "Maison de ville",
              "Palace",
              "Penthouse",
              "Château",
              "Site historique",
              "Site archéologique",
              "Statue",
              "Amphithéâtre",
              "Mausolée",
              "Monument",
              "Gratte-ciel",
              "Bâtiment gouvernemental",
              "Église",
              "Complexe fortifié",
              "Opéra",
              "Musée",
              "Résidence royale",
              "Château historique",
              "Palais impérial",
              "Cathédrale",
              "Basilique",
              "Pont",
              "Complexe hôtelier",
              "Complexe historique",
              "Édifice religieux",
              "Temple",
              "Tour d'observation",
              "Île monastique",
              "Pyramide",
              "Sanctuaire",
              "Résidence présidentielle",
              "Bibliothèque",
              "Palais de justice",
              "Centre culturel",
              "Hôtel",
              "Bâtiment résidentiel",
              "Exposition",
              "Bâtiment",
              "Barrage",
              "Centre d'art contemporain",
              "Bureau",
              "Salle de concert",
              "Parc public",
              "Siège social",
              "Centre de congrès",
              "Observatoire",
              "Tour"
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<RealEstate>>(
        future: widget.realEstateService.getPropertiesByTypeAndStyle(selectedType, "Exotic"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading exotic real estate: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No exotic real estate available."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RealEstate realEstate = snapshot.data![index];
                return ListTile(
                  title: Text(realEstate.name),
                  subtitle: Text('Price: \$${realEstate.value.toStringAsFixed(2)}'),
                  onTap: () => _selectAccountAndPurchase(context, realEstate),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _selectAccountAndPurchase(BuildContext context, RealEstate realEstate) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          children: widget.person.bankAccounts.map<Widget>((BankAccount account) {
            return ListTile(
              title: Text('${account.bankName} - ${account.accountType}'),
              subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
              onTap: () => _showPurchaseOptions(context, realEstate, account),
            );
          }).toList(),
        );
      },
    );
  }


  void _showPurchaseOptions(BuildContext context, RealEstate realEstate, BankAccount account) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Purchase Options"),
          content: Text("Choose your payment method for ${realEstate.name}."),
          actions: <Widget>[
            TextButton(
              child: Text("Pay Cash"),
              onPressed: () {
                Navigator.pop(context);
                _attemptPurchase(account, realEstate, context);
              },
            ),
            TextButton(
              child: Text("Apply For Loan"),
              onPressed: () {
                Navigator.pop(context);
                _attemptLoan(account, realEstate, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _attemptPurchase(BankAccount account, RealEstate realEstate, BuildContext context) {
    widget.transactionService.attemptPurchase(
      account,
      realEstate,
      onSuccess: () async {
        widget.person.addRealEstate(realEstate);

        final event = LifeHistoryEvent(
          description: "${widget.person.name} purchased the exotic real estate ${realEstate.name} for \$${realEstate.value.toStringAsFixed(2)}.",
          timestamp: DateTime.now(),
          ageAtEvent: widget.person.age,
          personId: widget.person.id,
        );
        await LifeHistoryService().saveEvent(event);

        _showSuccessDialog(context, "You have successfully purchased ${realEstate.name}.");
      },
      onFailure: (String message) {
        _showErrorDialog(context, message);
      },
    );
  }

  void _attemptLoan(BankAccount account, RealEstate realEstate, BuildContext context) {
    widget.transactionService.attemptPurchase(
      account,
      realEstate,
      useLoan: true,
      loanTerm: 30, // Example loan term
      loanInterestRate: 5.0, // Example interest rate
      onSuccess: () async {
        widget.person.addRealEstate(realEstate);

        final event = LifeHistoryEvent(
          description: "${widget.person.name} purchased the exotic real estate ${realEstate.name} with a loan for \$${realEstate.value.toStringAsFixed(2)}.",
          timestamp: DateTime.now(),
          ageAtEvent: widget.person.age,
          personId: widget.person.id,
        );
        await LifeHistoryService().saveEvent(event);

        _showSuccessDialog(context, "Loan approved and ${realEstate.name} purchased.");
      },
      onFailure: (String message) {
        _showErrorDialog(context, message);
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Purchase Successful"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
