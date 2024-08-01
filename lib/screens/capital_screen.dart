import 'package:flutter/material.dart';

class CapitalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Capital and Assets'),
      ),
      body: Center(
        child: Text('Details about capital and assets will be displayed here.'),
      ),
    );
  }
}
