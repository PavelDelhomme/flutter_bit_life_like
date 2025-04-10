import 'package:bitlife_like/models/work/business.dart';
import 'package:flutter/material.dart';

class BusinessScreen extends StatelessWidget {
  final Business business;

  const BusinessScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(business.name)),
      body: Column(
        children: [
          _buildFinancialSummary(),
          Expanded(
            child: ListView(
              children: [
                _buildEmployeesSection(),
                _buildLoansSection(),
                _buildPropertiesSection(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Capital : \$${business.capital.toStringAsFixed(2)}"),
            Text('Valorisation: \$${business.valuation.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesSection() {
    return ExpansionTile(
      title: const Text('Employés'),
      children: business.employees.map((e) => ListTile(
        title: Text(e.name),
        subtitle: Text('Salaire: \$${e.salary.toStringAsFixed(2)}'),
      )).toList(),
    );
  }
  Widget _buildLoansSection() {
    return ExpansionTile(
      title: const Text('Emprunts'),
      children: business.employees.map((e) => ListTile(
        title: Text(e.name),
        subtitle: Text('Salaire: \$${e.salary.toStringAsFixed(2)}'),
      )).toList(),
    );
  }
  Widget _buildPropertiesSection() {
    return ExpansionTile(
      title: const Text('Propriété'),
      children: business.employees.map((e) => ListTile(
        title: Text(e.name),
        subtitle: Text('Salaire: \$${e.salary.toStringAsFixed(2)}'),
      )).toList(),
    );
  }
}