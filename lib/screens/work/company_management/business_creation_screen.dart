import 'package:flutter/material.dart';
import '../../../Classes/person.dart';
import '../classes/business.dart';

class BusinessCreationScreen extends StatefulWidget {
  final Person person;

  BusinessCreationScreen({required this.person});

  @override
  _BusinessCreationScreenState createState() => _BusinessCreationScreenState();
}

class _BusinessCreationScreenState extends State<BusinessCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Business'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Business Name'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Business Type'),
            ),
            TextField(
              controller: _investmentController,
              decoration: InputDecoration(labelText: 'Initial Investment'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _productController,
              decoration: InputDecoration(labelText: 'Initial Product/Service'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Create Business'),
              onPressed: () {
                _createBusiness();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createBusiness() {
    String name = _nameController.text;
    String type = _typeController.text;
    double investment = double.tryParse(_investmentController.text) ?? 0;
    String product = _productController.text;

    if (investment > 0 && name.isNotEmpty && type.isNotEmpty && product.isNotEmpty) {
      widget.person.startBusiness(name, type, investment);
      widget.person.businesses.last.addProduct(product);
      Navigator.of(context).pop(); // Return to previous screen
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields with valid values')),
      );
    }
  }
}
