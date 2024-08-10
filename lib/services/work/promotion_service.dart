import 'dart:math';

import 'package:bit_life_like/screens/work/classes/job.dart';

import '../../Classes/person.dart';


class PromotionService {
  final Random _random = Random();

  void evaluatePromotion(Person person) {
    person.jobs.forEach((job) {
      if (_isEligibleForPromotion(person, job)) {
        job.salary *= 1.2; // 20% raise
        job.title += " (Senior)";
        print("Congratulations! You have been promoted to ${job.title}.");
      } else {
        print("You need more experience for a promotion.");
      }
    });
  }

  bool _isEligibleForPromotion(Person person, Job job) {
    return person.jobs.length > 2 && _random.nextDouble() > 0.5; // 50% chance
  }
}