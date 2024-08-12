import 'dart:convert';

import 'package:bit_life_like/screens/market_place/marketplace.dart';
import 'package:flutter/material.dart';
import 'package:bit_life_like/screens/home_screen.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';
import 'package:bit_life_like/services/bank/FinancialService.dart';
import 'package:bit_life_like/services/bank/transaction_service.dart';
import 'package:bit_life_like/services/events_decision/DecisionService.dart';
import 'package:bit_life_like/services/justice/justice_service.dart';
import 'package:bit_life_like/services/work/career_service.dart';
import 'package:bit_life_like/services/work/jobmarket_service.dart'; // Import job market service
import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';
import 'package:bit_life_like/Classes/objects/vehicle.dart';
import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/Classes/objects/jewelry.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String eventData = await rootBundle.loadString('assets/events.json');
  List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(jsonDecode(eventData)['events']);
  await FinancialService.loadBankData(); // Make sure bank data is loaded before the app starts
  runApp(MyApp(events: events));
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final Person person = setupDemo(); // Assuming setupDemo now returns Person
  final RealEstateService realEstateService = RealEstateService();
  final TransactionService transactionService = TransactionService();

  MyApp({required this.events});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        person: person,
        realEstateService: realEstateService,
        transactionService: transactionService,
        events: events,
      ),
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
          balance: 9000000000000,
          annualIncome: 50000,
          accountType: 'Checking')
    ],
    age: 30,
    health: 100,
    appearance: 100,
    happiness: 100,
    karma: 100,
    intelligence: 100,
    isImprisoned: false,
    prisonTerm: 0,
  );

  // Create services
  DecisionService decisionService = DecisionService();
  CareerService careerService = CareerService();
  JusticeService justiceService = JusticeService();
  TransactionService transactionService = TransactionService();
  FinancialService financialService = FinancialService.instance;
  JobMarketService jobMarketService = JobMarketService(); // Add job market service

  // Load available jobs
  jobMarketService.loadJobs().then((_) {
    if (jobMarketService.availableJobs.isNotEmpty) {
      // Select the first available job for demo purposes
      MarketJob marketJob = jobMarketService.availableJobs.first;

      // Apply for the job using the career service
      careerService.applyForJob(person, marketJob);
    } else {
      print("No jobs available in the market");
    }
  });

  // Setup marketplaces for different items
  Marketplace<Vehicle> vehicleMarketplace = Marketplace<Vehicle>();
  Marketplace<RealEstate> realEstateMarketplace = Marketplace<RealEstate>();
  Marketplace<Jewelry> jewelryMarketplace = Marketplace<Jewelry>();

  // Simulate some actions
  decisionService.makeDecision(person, "Invest in Real Estate");
  justiceService.defendInCourt(person, "Traffic Violation");
  transactionService.purchaseItem(person.bankAccounts.first, 5000, () => print("Purchase successful!"), () => print("Insufficient funds."));
  financialService.applyForLoan(person.bankAccounts.first, 50000, 5, 3.5); // Apply for a loan with specified terms

  // Print information about marketplaces to ensure everything is set up
  print(vehicleMarketplace.toString());
  print(realEstateMarketplace.toString());
  print(jewelryMarketplace.toString());
  return person;
}
