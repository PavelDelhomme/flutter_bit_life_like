import 'package:bit_life_like/services/event_service.dart';
import 'package:flutter/material.dart';
import 'financial_service.dart';
import 'loan_service.dart';
import 'career_service.dart';
import 'justice_service.dart';
import 'transaction_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitLife Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final EventService eventService = EventService();
  final FinancialService financialService = FinancialService();
  final DecisionService decisionService = DecisionService();
  final LoanService loanService = LoanService();
  final CareerService careerService = CareerService();
  final JusticeService justiceService = JusticeService();
  final TransactionService transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    Person person = Person(name: 'John Doe', gender: 'Male', country: 'USA', currency: 'USD');
    return Scaffold(
      appBar: AppBar(
        title: Text('BitLife Clone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome ${person.name}!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                eventService.triggerRandomEvent(person);
              },
              child: Text('Trigger Event'),
            ),
            ElevatedButton(
              onPressed: () {
                financialService.investInStock(person.bankAccount, 1000);
              },
              child: Text('Invest in Stock'),
            ),
            ElevatedButton(
              onPressed: () {
                loanService.requestLoan(person.bankAccount, 5000);
              },
              child: Text('Request Loan'),
            ),
            ElevatedButton(
              onPressed: () {
                decisionService.makeDecision(person, 'commit_crime');
              },
              child: Text('Commit Crime'),
            ),
            ElevatedButton(
              onPressed: () {
                justiceService.commitCrime(person, 'robbery');
              },
              child: Text('Commit Robbery'),
            ),
          ],
        ),
      ),
    );
  }
}
