import 'dart:math';

class Interview {
  static final Random _random = Random();

  static final List<Map<String, String>> _questions = [
    {
      'question': 'Tell me about a time you faced a challenge at work.',
      'answer': 'I tackled a project with tight deadlines, managed my time effectively, and delivered it successfully.',
    },
    {
      'question': 'Why do you want to work with us?',
      'answer': 'Your company values align with my career goals, and I believe I can contribute to your success.',
    },
    {
      'question': 'What are your strengths?',
      'answer': 'I am highly organized, a great communicator, and a quick learner.',
    },
    {
      'question': 'How do you handle stress?',
      'answer': 'I prioritize tasks, stay focused, and use stress as motivation to achieve results.',
    },
  ];

  static bool simulate() {
    int questionIndex = _random.nextInt(_questions.length);
    print("Interview Question: ${_questions[questionIndex]['question']}");
    print("Expected Answer: ${_questions[questionIndex]['answer']}");

    // Simulate an interview where the candidate gets 75% chance to pass
    return _random.nextDouble() > 0.25;
  }
}