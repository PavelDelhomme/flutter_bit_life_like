import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class PermitQuestion {
  final String question;
  final Map<String, String> choices;
  final String correctAnswer;

  PermitQuestion({required this.question, required this.choices, required this.correctAnswer});

  factory PermitQuestion.fromJson(Map<String, dynamic> json) {
    return PermitQuestion(
      question: json['question'] as String,
      choices: Map<String, String>.from(json['choices'] as Map),
      correctAnswer: json['correct_answer'] as String,
    );
  }
}

class PermitQuestionLoader {
  static Future<Map<String, List<PermitQuestion>>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/permit_questions.json');
    final data = json.decode(response) as Map<String, dynamic>;

    return data['permit_questions'].map<String, List<PermitQuestion>>((key, value) {
      List<PermitQuestion> questions = (value as List<dynamic>)
          .map((q) => PermitQuestion.fromJson(q as Map<String, dynamic>))
          .toList();
      return MapEntry(key as String, questions);
    });
  }
}
