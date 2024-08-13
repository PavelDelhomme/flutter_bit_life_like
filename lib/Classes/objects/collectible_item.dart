abstract class CollectibleItem {
  final String name;
  final double value;
  final String? rarity;
  final String? epoch;

  CollectibleItem({
    required this.name,
    required this.value,
    this.rarity,
    this.epoch,
  });

  String display();

  Map<String, dynamic> toJson();
}
