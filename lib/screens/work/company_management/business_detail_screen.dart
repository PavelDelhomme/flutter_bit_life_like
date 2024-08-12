import 'package:bit_life_like/services/work/hr_service.dart';
import 'package:bit_life_like/services/work/jobmarket_service.dart';
import 'package:flutter/material.dart';
import '../classes/business.dart';
import '../classes/interview_simulation.dart';

class BusinessDetailScreen extends StatefulWidget {
  final Business business;

  BusinessDetailScreen({required this.business});

  @override
  _BusinessDetailScreenState createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final HrService hrService = HrService();
  final JobMarketService jobmarketServices = JobMarketService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.business.name} Details'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text('Products'),
            children: [
              ...widget.business.products.map((product) => ListTile(
                title: Text(product.name),
                subtitle: Text("Price: \$${product.price}, Cost : \$${product.productionCost}"),
              )),
              ListTile(
                title: Text("Add Product"),
                trailing: Icon(Icons.add),
                onTap: () {
                  _showAddProductDialog(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Employees"),
            children: [
              ...widget.business.employees.map((employee) => ListTile(
                title: Text(employee.name),
                subtitle: Text("Salary: \$${employee.salary}"),
              )),
              ListTile(
                title: Text("Add Employee"),
                trailing: Icon(Icons.add),
                onTap: () {
                  _showAddEmployeeDialog(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Departments'),
            children: [
              ...widget.business.departments.map((department) => ListTile(
                title: Text(department.name),
                onTap: () => _showDepartmentDetails(context, department),
              )),
              ListTile(
                title: Text("Add Department"),
                trailing: Icon(Icons.add),
                onTap: () {
                  _showAddDepartmentDialog(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Financial Management"),
            children: [
              ListTile(
                title: Text("Balance"),
                subtitle: Text("\$${widget.business.getBalance()}"),
              ),
              ListTile(
                title: Text("Pay Salaries"),
                onTap: () {
                  widget.business.paySalaries();
                  print("Salaries paid for employees in ${widget.business.name}");
                  setState(() {});
                },
              ),
              ListTile(
                title: Text("Pay Taxes"),
                onTap: () {
                  widget.business.payTaxes();
                  print("Taxes paid for ${widget.business.name}");
                  setState(() {});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Strategic Management"),
            children: [
              ListTile(
                title: Text("Strategies"),
                subtitle: Text(widget.business.strategies.map((s) => s.description).join(', ')),
                onTap: () {
                  _showAddStrategyDialog(context);
                },
              ),
              ListTile(
                title: Text("Conduc Marketing Campaign"),
                onTap: () {
                  _showMarketingCampaignDialog(context);
                },
              ),
              ListTile(
                title: Text("Expand Internationally"),
                onTap: () {
                  _showExpansionDialog(context);
                },
              ),
              ListTile(
                title: Text("Automate Processes"),
                onTap: () {
                  _showAutomationDialog(context);
                },
              ),
              ListTile(
                title: Text("Engage in CSR"),
                onTap: () {
                  _showCSRDialog(context);
                },
              ),
              ListTile(
                title: Text("Transfer Ownership"),
                onTap: () {
                  // Implement Transfer Ownership Logic
                },
              ),
            ],
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
                String productName = productController.text;
                if (productName.isNotEmpty) {
                  widget.business.addProduct(Product(name: productName, price: 100, productionCost: 50) as String);
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    jobmarketServices.loadJobs().then((_) {
      List<Candidate> candidates = Interview.getAvailableCandidates();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Employee"),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: candidates.length,
                itemBuilder: (BuildContext context, int index) {
                  Candidate candidate = candidates[index];
                  return ListTile(
                    title: Text(candidate.name),
                    subtitle: Text("Expected Salary: \$${candidate.expectedSalary.toStringAsFixed(2)}"),
                    onTap: () {
                      if (Interview.simulate(candidate)) {
                        Department department = widget.business.departments.isNotEmpty
                            ? widget.business.departments.first
                            : Department(name: 'General');
                        widget.business.hireEmployee(candidate.name, candidate.expectedSalary, department);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${candidate.name} has been hired!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${candidate.name} failed the interview.")),
                        );
                      }
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    });
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
                String departmentName = departmentController.text;
                if (departmentName.isNotEmpty) {
                  widget.business.addDepartment(Department(name: departmentName) as String);
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDepartmentDetails(BuildContext context, Department department) {
    // Implement logic to show details about the department
    print("Showing details for department: ${department.name}");
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
                widget.business.addStrategy(Strategy(strategy));
                Navigator.of(context).pop();
                setState(() {});
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
                widget.business.conductMarketingCampaign(campaign);
                Navigator.of(context).pop();
                setState(() {});
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
                widget.business.expandInternationally(market);
                Navigator.of(context).pop();
                setState(() {});
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
                widget.business.automateProcesses();
                Navigator.of(context).pop();
                setState(() {});
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
                widget.business.engageInCSR(initiative);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}