import 'package:flutter/material.dart';

class SomeArtDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Art Details"),
      ),
      body: Center(
        child: Text("Here are the details of a specific piece of art."),
      ),
    );
  }
}