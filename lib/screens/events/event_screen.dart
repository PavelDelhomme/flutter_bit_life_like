import 'package:flutter/material.dart';
import '../../Classes/person.dart';
import '../../Classes/event.dart';

class EventScreen extends StatelessWidget {
  final Event event;
  final Person person;
  final Function(Event event, String choice) onChoiceMade;

  EventScreen({
    required this.event,
    required this.person,
    required this.onChoiceMade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (event.choices != null)
              ...event.choices!.keys.map((choice) {
                return ElevatedButton(
                  onPressed: () {
                    onChoiceMade(event, choice);
                    Navigator.pop(context);
                  },
                  child: Text(choice),
                );
              }).toList(),
            if (event.choices == null)
              ElevatedButton(
                onPressed: () {
                  onChoiceMade(event, '');
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
          ],
        ),
      ),
    );
  }

}