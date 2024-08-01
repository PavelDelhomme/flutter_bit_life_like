abstract class CollectibleItem {
  late String name;
  late double value;
  late String rarity;
  late String epoch;

  CollectibleItem({
    required this.name,
    required this.value,
    required this.rarity,
    required this.epoch,
  });

  String display();
}