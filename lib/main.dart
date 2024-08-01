import 'package:bit_life_like/screens/marketplace_menu_screen.dart';
import 'package:bit_life_like/services/DecisionService.dart';
import 'package:bit_life_like/services/FinancialService.dart';
import 'package:bit_life_like/services/bank_account.dart';
import 'package:bit_life_like/services/career_service.dart';
import 'package:bit_life_like/services/justice_service.dart';
import 'package:bit_life_like/services/loan_service.dart';
import 'package:bit_life_like/services/transaction_service.dart';
import 'package:flutter/material.dart';

import 'Classes/jewelry.dart';
import 'Classes/job.dart';
import 'Classes/marketplace.dart';
import 'Classes/person.dart';
import 'Classes/real_estate.dart';
import 'Classes/vehicle.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MarketplaceMenuScreen(),
    );
  }
}

void setupDemo() {
  // Create a person with a bank account
  BankAccount account = BankAccount(balance: 10000);
  Person person = Person(name: 'John Doe', gender: 'Male', country: 'USA', bankAccount: account);

  // Create services
  DecisionService decisionService = DecisionService();
  LoanService loanService = LoanService();
  CareerService careerService = CareerService();
  JusticeService justiceService = JusticeService();
  TransactionService transactionService = TransactionService();
  FinancialService financialService = FinancialService();

  // Create marketplace
  Marketplace<Vehicle> vehicleMarketplace = Marketplace<Vehicle>();
  Marketplace<RealEstate> realEstateMarketplace = Marketplace<RealEstate>();
  Marketplace<Jewelry> jewelryMarketplace = Marketplace<Jewelry>();

  // Add some items to marketplaces
  vehicleMarketplace.addVehicleToMarket(Moto(name: 'Yamaha MT-09', age: 2, value: 10000, rarity: 'Common', brand: 'Yamaha', fuelConsumption: 5.5));
  vehicleMarketplace.addVehicleToMarket(Voiture(name: 'Tesla Model S', age: 1, value: 80000, rarity: 'Rare', brand: 'Tesla', fuelConsumption: 0));

  realEstateMarketplace.addItemToMarket(RealEstate(name: 'Luxury Villa', age: 2, value: 2000000, type: 'Villa', condition: 'New', monthlyMaintenanceCost: 2000, estLouee: false));
  jewelryMarketplace.addItemToMarket(Jewelry(name: 'Diamond Ring', value: 10000, rarity: 'Rare', brand: 'Tiffany & Co.', carat: 2.0));

  // Simulate some actions
  decisionService.makeDecision(person, 'start_business');
  loanService.applyForLoan(account, 50000);
  careerService.applyForJob(person, Job(title: 'Software Engineer', salary: 80000, country: person.country, hoursPerWeek: 35));
  justiceService.defendInCourt(person, 'theft');
  transactionService.transferFunds(account, BankAccount(balance: 5000), 1000);
  financialService.investInStock(account, 2000);

  print(vehicleMarketplace.toString());
  print(realEstateMarketplace.toString());
  print(jewelryMarketplace.toString());
}
