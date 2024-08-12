class Book {
  String title;
  String author;
  Map<String, double> skills;

  Book({required this.title, required this.author, required this.skills});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      skills: Map<String, double>.from(json['skills'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'skills': skills,
    };
  }
}
