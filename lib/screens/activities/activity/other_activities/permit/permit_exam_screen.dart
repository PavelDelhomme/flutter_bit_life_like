import 'package:bit_life_like/Classes/person.dart';
import 'package:bit_life_like/Classes/life_history_event.dart';
import 'package:bit_life_like/services/life_history.dart';
import 'package:bit_life_like/services/life_state.dart';
import 'package:flutter/material.dart';

import '../../../../../Classes/permit_question.dart';

class PermitExamScreen extends StatefulWidget {
  final String permitType;
  final Person person;

  PermitExamScreen({required this.permitType, required this.person});

  @override
  _PermitExamScreenState createState() => _PermitExamScreenState();
}

class _PermitExamScreenState extends State<PermitExamScreen> {
  List<PermitQuestion> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  Map<String, List<PermitQuestion>> permitQuestions = {};

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    permitQuestions = await PermitQuestionLoader.loadQuestions();
    questions = permitQuestions[widget.permitType] ?? [];
    setState(() {});
  }

  void checkAnswer(String selectedAnswer) {
    if (questions[currentQuestionIndex].correctAnswer == selectedAnswer) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() async {
    bool passed = score >= questions.length * 0.8;
    String resultMessage = passed
        ? "Congratulation! You passed the ${widget.permitType} permit exam."
        : "Unfortunately, you did not pass the exam. Try again!";

    if (passed) {
      widget.person.addPermit(widget.permitType);
      await _saveHistoryEvent("Passed the ${widget.permitType} permit exam.");
    } else {
      await _saveHistoryEvent("Failed the ${widget.permitType} permit exam.");
    }

    final events = await LifeHistoryService().getEvents();
    await LifeStateService(personService: personService).saveLifeState(widget.person, events);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(passed ? "Passed!" : "Failed"),
          content: Text(resultMessage),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _saveHistoryEvent(String description) async {
    final event = LifeHistoryEvent(
      description: description,
      timestamp: DateTime.now(),
    );
    await LifeHistoryService().saveEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Permit Exam")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Permit Exam")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ...currentQuestion.choices.entries.map((choice) {
              return ElevatedButton(
                onPressed: () => checkAnswer(choice.key),
                child: Text("${choice.key}: ${choice.value}"),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
