
import '../../../core/models/asset.dart';
import '../../../core/shared/inventory_item.dart';

class Book implements InventoryItem {
  @override
  final String id;
  final String title;
  final String author;
  final double readingTime; // todo trouver autre chose que ca
  final double comprehensionRequired; // 0.0-1.0
  @override
  final Map<String, double> skillEffects;

  @override
  double get value => skillEffects.values.fold(0, (a, b) => a + b); // ou un champ `value` direct

  @override
  String get name => title;

  @override
  AssetType get type => AssetType.book;


  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.skillEffects,
    this.readingTime = 10.0,
    this.comprehensionRequired = 0.5,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'skillEffects': skillEffects,
      'readingTime': readingTime,
      'comprehensionRequired': comprehensionRequired,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      skillEffects: Map<String, double>.from(json['skillEffects']),
      readingTime: json['readingTime'],
      comprehensionRequired: json['comprehensionRequired'],
    );
  }
}