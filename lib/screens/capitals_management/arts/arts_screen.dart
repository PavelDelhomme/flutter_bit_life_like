import 'package:bit_life_like/Classes/person.dart';
import 'package:flutter/material.dart';
import 'some_art_detail_screen.dart';

class ArtsScreen extends StatelessWidget {
  final Person person;

  ArtsScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arts"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("View Some Art"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SomeArtDetailScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}