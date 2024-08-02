import 'package:bit_life_like/screens/home_screen.dart';
import 'package:bit_life_like/screens/market_place/marketplace.dart';
import 'package:flutter/material.dart';
import 'package:bit_life_like/screens/market_place/marketplace_menu_screen.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:bit_life_like/services/events_decision/DecisionService.dart';
import 'package:bit_life_like/services/justice/justice_service.dart';
import 'package:bit_life_like/services/work/career_service.dart';
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FinancialService.loadBankData();  // Make sure bank data is loaded before the app starts
  runApp(MyApp());
  setupDemo(); // Setup the demo after the app is running
}

class MyApp extends StatelessWidget {
  final Person person = setupDemo(); // Assuming setupDemo now returns Person

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(person: person),
      debugShowCheckedModeBanner: false,
    );
  }
}

Person setupDemo() {
  // Create a person with bank accounts
  Person person = Person(
      name: 'John Doe',
      gender: 'Male',
      country: 'USA',
      bankAccounts: [
        BankAccount(
            accountNumber: 'ACC1001',
            bankName: 'Bank of Simulator',
            balance: 10000,
            annualIncome: 50000,
            accountType: 'Checking'
        )
      ]
  );

  // Create services
  DecisionService decisionService = DecisionService();
  CareerService careerService = CareerService();
  JusticeService justiceService = JusticeService();
  TransactionService transactionService = TransactionService();
  FinancialService financialService = FinancialService.instance;

  // Setup marketplaces for different items
  Marketplace<Vehicle> vehicleMarketplace = Marketplace<Vehicle>();
  Marketplace<RealEstate> realEstateMarketplace = Marketplace<RealEstate>();
  Marketplace<Jewelry> jewelryMarketplace = Marketplace<Jewelry>();

  // Simulate some actions
  decisionService.makeDecision(person, "Invest in Real Estate");
  careerService.applyForJob(person, 'Software Engineer');
  justiceService.defendInCourt(person, "Traffic Violation");
  transactionService.purchaseItem(person.bankAccounts.first, 5000, () => print("Purchase successful!"), () => print("Insufficient funds."));
  financialService.applyForLoan(person.bankAccounts.first, 50000, 5, 3.5);  // Apply for a loan with specified terms

  // Print information about marketplaces to ensure everything is set up
  print(vehicleMarketplace.toString());
  print(realEstateMarketplace.toString());
  print(jewelryMarketplace.toString());
  return person;
}

