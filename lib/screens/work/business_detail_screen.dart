import 'package:flutter/material.dart';
import '../../screens/work/classes/business.dart';

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
            subtitle: Text('${business.employees.join(', ')}'),
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Employee"),
          content: TextField(
            controller: employeeController,
            decoration: InputDecoration(labelText: "Employee Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                String employee = employeeController.text;
                business.hireEmployee(employee);
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
}