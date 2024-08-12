import 'package:flutter/material.dart';

import '../../../../Classes/person.dart';

class EmigrationScreen extends StatelessWidget {
  final Person person;

  EmigrationScreen({required this.person});

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
