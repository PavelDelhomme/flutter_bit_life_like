import 'collectible_item.dart';
import 'package:bit_life_like/services/bank/bank_account.dart';

class Art extends CollectibleItem implements Purchasable {
  final String name;
  final double value;
  final String rarity;
  final String epoch;
  final String dateOfCreation;
  final String artist;
  final String type;

  Art({
    required this.name,
    required this.value,
    required this.rarity,
    required this.epoch,
    required this.dateOfCreation,
    required this.artist,
    required this.type,
  }) : super(
    name: name,
    value: value,
    rarity: rarity,
    epoch: epoch,
  );

  @override
  String display() {
    return '$type: $name, Created by: $artist in $dateOfCreation, Value: \$${value.toString()}, Rarity: $rarity';
  }

  factory Art.fromJson(Map<String, dynamic> json) {
    return Art(
      name: json['nom'] as String,
      value: (json['valeur'] as num).toDouble(), // Ensure correct type
      rarity: 'Unknown', // Assuming rarity is not provided
      epoch: 'Unknown', // Assuming epoch is not provided
      dateOfCreation: json['date_de_creation'] as String,
      artist: json['artiste'] as String,
      type: json['type'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
