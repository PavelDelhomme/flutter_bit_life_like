import 'dart:math';

class ProbabilityEngine {
  final Random _random;

  ProbabilityEngine({int? seed}) : _random = Random(seed);

  /// Renvoie true avec une probabilité [chance] (entre 0.0 et 1.0)
  bool roll(double chance) {
    assert(chance >= 0.0 && chance <= 1.0);
    return _random.nextDouble() < chance;
  }

  /// Renvoie une valeur aléatoire selon des poids personnalisés
  T weightedRandom<T>(Map<T, double> weights) {
    final totalWeight = weights.values.fold(0.0, (sum, w) => sum + w);
    final threshold = _random.nextDouble() * totalWeight;
    double cumulative = 0.0;

    for (var entry in weights.entries) {
      cumulative += entry.value;
      if (threshold <= cumulative) {
        return entry.key;
      }
    }

    // fallback
    return weights.keys.first;
  }

  /// Renvoie une valeur aléatoire dans l'intervalle donné
  double randomInRange(double min, double max) {
    return min + (_random.nextDouble() * (max - min));
  }

  /// Renvoie un élément aléatoire dans la liste
  T randomValue<T>(List<T> values) {
    if (values.isEmpty)  throw ArgumentError("La liste ne peux être vide");
    return values[_random.nextInt(values.length)];
  }

  /// Renvoie la [value] avec une probabilité donnée, sinon null
  T? chanceValue<T>(double chance, T value) {
    return roll(chance) ? value : null;
  }
}