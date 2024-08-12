import 'package:flutter/material.dart';

import '../classes/business.dart';

class BusinessDetailScreen extends StatelessWidget {
  final Business business;

  BusinessDetailScreen({required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${business.name} Details'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Products'),
            subtitle: Text('${business.products.join(', ')}'),
            onTap: () {
              _showAddProductDialog(context);
            },
          ),
          ListTile(
            title: Text('Employees'),
            subtitle: Text('${business.employees.map((e) => e.name).join(', ')}'),
            onTap: () {
              _showAddEmployeeDialog(context);
            },
          ),
          ListTile(
            title: Text('Departments'),
            subtitle: Text('${business.departments.join(', ')}'),
            onTap: () {
              _showAddDepartmentDialog(context);
            },
          ),
          ListTile(
            title: Text('Balance'),
            subtitle: Text('\$${business.getBalance()}'),
          ),
          ListTile(
            title: Text('Real Estate'),
            onTap: () {
              // Navigate to real estate management screen
            },
          ),
          ListTile(
            title: Text('Pay Salaries'),
            onTap: () {
              business.paySalaries();
              print("Salaries paid for employees in ${business.name}");
            },
          ),
          ListTile(
            title: Text('Pay Taxes'),
            onTap: () {
              business.payTaxes();
              print("Taxes paid for ${business.name}");
            },
          ),
          ListTile(
            title: Text('Strategies'),
            subtitle: Text('${business.strategies.join(', ')}'),
            onTap: () {
              _showAddStrategyDialog(context);
            },
          ),
          ListTile(
            title: Text('SWOT Analysis'),
            subtitle: Text('Strength: ${business.swotAnalysis['Strength']}\n'
                'Weakness: ${business.swotAnalysis['Weakness']}\n'
                'Opportunity: ${business.swotAnalysis['Opportunity']}\n'
                'Threat: ${business.swotAnalysis['Threat']}'),
            onTap: () {
              _showSWOTAnalysisDialog(context);
            },
          ),
          ListTile(
            title: Text('Conduct Marketing Campaign'),
            onTap: () {
              _showMarketingCampaignDialog(context);
            },
          ),
          ListTile(
            title: Text('Expand Internationally'),
            onTap: () {
              _showExpansionDialog(context);
            },
          ),
          ListTile(
            title: Text('Automate Processes'),
            onTap: () {
              _showAutomationDialog(context);
            },
          ),
          ListTile(
            title: Text('Engage in CSR'),
            onTap: () {
              _showCSRDialog(context);
            },
          ),
          ListTile(
            title: Text('Transfer Ownership'),
            onTap: () {
              // Implement ownership transfer logic
            },
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    TextEditingController productController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: TextField(
            controller: productController,
            decoration: InputDecoration(labelText: "Product Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                String product = productController.text;
                business.addProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    TextEditingController employeeController = TextEditingController();
    TextEditingController salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Employee"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: employeeController,
                decoration: InputDecoration(labelText: "Employee Name"),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: "Salary"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                String name = employeeController.text;
                double salary = double.tryParse(salaryController.text) ?? 0;
                business.hireEmployee(name, salary);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddDepartmentDialog(BuildContext context) {
    TextEditingController departmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Department"),
          content: TextField(
            controller: departmentController,
            decoration: InputDecoration(labelText: "Department Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                String department = departmentController.text;
                business.addDepartment(department);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddStrategyDialog(BuildContext context) {
    TextEditingController strategyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Strategy"),
          content: TextField(
            controller: strategyController,
            decoration: InputDecoration(labelText: "Strategy Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                String strategy = strategyController.text;
                business.addStrategy(strategy);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSWOTAnalysisDialog(BuildContext context) {
    TextEditingController strengthController = TextEditingController();
    TextEditingController weaknessController = TextEditingController();
    TextEditingController opportunityController = TextEditingController();
    TextEditingController threatController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("SWOT Analysis"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: strengthController,
                decoration: InputDecoration(labelText: "Strength"),
              ),
              TextField(
                controller: weaknessController,
                decoration: InputDecoration(labelText: "Weakness"),
              ),
              TextField(
                controller: opportunityController,
                decoration: InputDecoration(labelText: "Opportunity"),
              ),
              TextField(
                controller: threatController,
                decoration: InputDecoration(labelText: "Threat"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Set Analysis"),
              onPressed: () {
                business.setSWOTAnalysis(
                  strengthController.text,
                  weaknessController.text,
                  opportunityController.text,
                  threatController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMarketingCampaignDialog(BuildContext context) {
    TextEditingController campaignController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conduct Marketing Campaign"),
          content: TextField(
            controller: campaignController,
            decoration: InputDecoration(labelText: "Campaign Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Conduct"),
              onPressed: () {
                String campaign = campaignController.text;
                business.conductMarketingCampaign(campaign);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showExpansionDialog(BuildContext context) {
    TextEditingController marketController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Expand Internationally"),
          content: TextField(
            controller: marketController,
            decoration: InputDecoration(labelText: "Market Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Expand"),
              onPressed: () {
                String market = marketController.text;
                business.expandInternationally(market);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAutomationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Automate Processes"),
          content: Text("Automate business processes to improve efficiency."),
          actions: <Widget>[
            TextButton(
              child: Text("Automate"),
              onPressed: () {
                business.automateProcesses();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCSRDialog(BuildContext context) {
    TextEditingController initiativeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Engage in CSR"),
          content: TextField(
            controller: initiativeController,
            decoration: InputDecoration(labelText: "CSR Initiative"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Engage"),
              onPressed: () {
                String initiative = initiativeController.text;
                business.engageInCSR(initiative);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
