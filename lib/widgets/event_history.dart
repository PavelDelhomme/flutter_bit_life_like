import 'package:flutter/material.dart';
import '../models/event.dart';

class EventHistory extends StatelessWidget {
  final List<Event> lifeEvents;

  const EventHistory({super.key, required this.lifeEvents});

  @override
  Widget build(BuildContext context) {
    if (lifeEvents.isEmpty) {
      return const Center(
        child: Text(
          'Aucun événement pour le moment',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    // Grouper les événements par âge
    final eventsByAge = <int, List<Event>>{};
    for (final event in lifeEvents) {
      eventsByAge.putIfAbsent(event.age, () => []).add(event);
    }

    final ageGroups = eventsByAge.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ageGroups.length,
      itemBuilder: (context, index) {
        final age = ageGroups[index];
        final events = eventsByAge[age]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Âge : $age an${age > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...events.map((event) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
            const Divider(),
          ],
        );
      },
    );
  }
}
