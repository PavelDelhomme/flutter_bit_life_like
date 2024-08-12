import 'package:flutter/material.dart';

import '../../../../Classes/person.dart';

class InheritanceScreen extends StatelessWidget {
  final Person person;

  InheritanceScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sport Activities'),
      ),
      body: Center(
        child: Text('List of sport activities here'),
      ),
    );
  }
}
