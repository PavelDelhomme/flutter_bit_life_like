import 'dart:math';

class RandomGenerator {
  final Random _random = Random();

  double nextDouble() => _random.nextDouble();

  int nextInt(int max) => _random.nextInt(max);

  bool chance(double probability) => _random.nextDouble() < probability;

  T? pickOne<T>(List<T> items) {
    if (items.isEmpty) return null;
    return items[_random.nextInt(items.length)];
  }
}
