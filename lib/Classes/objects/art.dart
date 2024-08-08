import 'collectible_item.dart';

class Art extends CollectibleItem {
  String dateOfCreation;
  String artist;
  String type;

  Art({
    required String name,
    required double value,
    required String rarity,
    required String epoch,
    required this.dateOfCreation,
    required this.artist,
    required this.type,
  }) : super(
      name: name,
      value: value,
      rarity: rarity,
      epoch: epoch
  );

  @override
  String display() {
    return '$type: $name, Created by: $artist in $dateOfCreation, Value: \$${value.toString()}, Rarity: $rarity';
  }

  factory Art.fromJson(Map<String, dynamic> json) {
    return Art(
      name: json['nom'] as String,
      value: json['valeur'] as double,
      rarity: 'Unknown',  // Assuming rarity is not provided
      epoch: 'Unknown',   // Assuming epoch is not provided
      dateOfCreation: json['date_de_creation'] as String,
      artist: json['artiste'] as String,
      type: json['type'] as String,
    );
  }
}
