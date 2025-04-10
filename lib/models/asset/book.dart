class Book {
  final String id;
  final String title;
  final String author;
  final Map<String, double> skillEffects;
  final double readingTime; // todo trouver autre chose que ca
  final double comprehensionRequired; // 0.0-1.0

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