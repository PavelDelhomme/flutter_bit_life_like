class Jewelry {
  final String name;
  final int value;
  final String rarity;
  final String brand;

  Jewelry({required this.name, required this.value, required this.rarity, required this.brand, required double carat});

  @override
  String toString() {
    return 'Jewelry: $name, Brand: $brand, Value: $value, Rarity: $rarity';
  }
}
