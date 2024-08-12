import 'package:flutter/material.dart';
import '../../../Classes/person.dart';

class CurrentEducationDetailsScreen extends StatefulWidget {
  final Person person;

  CurrentEducationDetailsScreen({required this.person});

  @override
  _CurrentEducationDetailsScreenState createState() => _CurrentEducationDetailsScreenState();
}

class _CurrentEducationDetailsScreenState extends State<CurrentEducationDetailsScreen> {
  double improvementFactor = 0.02;

  void improveSkills() {
    widget.person.currentEducation?.competences.forEach((skill, value) {
      widget.person.improveSkill(skill, value * improvementFactor);
    });

    setState(() {
      // Reduce the improvement factor each time the button is pressed
      improvementFactor = (improvementFactor / 2).clamp(0.001, improvementFactor);
    });

    print("Skills improved by ${improvementFactor * 100}%");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.person.currentEducation == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Current Education"),
        ),
        body: Center(
          child: Text("Not enrolled in any education program."),
        ),
      );
    }

    final currentEducation = widget.person.currentEducation!;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentEducation.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type: ${currentEducation.type}", style: TextStyle(fontSize: 16)),
            Text("Duration: ${currentEducation.duration} years", style: TextStyle(fontSize: 16)),
            Text("Annual Cost: \$${currentEducation.cost.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("Competences:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            for (var competence in currentEducation.competences.entries)
              Text("${competence.key}: ${competence.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 14)),
            Spacer(),
            ElevatedButton(
              onPressed: improveSkills,
              child: Text("Improve Skills"),
            ),
          ],
        ),
      ),
    );
  }
}
