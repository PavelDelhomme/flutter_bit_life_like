class JobOffer {
  final String id;
  final String title;
  final String companyName;
  final double salary;
  final int requiredEducationLevel; // Enum optionnel plus tard
  final List<String> requiredSkills;

  JobOffer({
    required this.id,
    required this.title,
    required this.companyName,
    required this.salary,
    this.requiredEducationLevel = 0,
    this.requiredSkills = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'companyName': companyName,
    'salary': salary,
    'requiredEducationLevel': requiredEducationLevel,
    'requiredSkills': requiredSkills,
  };

  factory JobOffer.fromJson(Map<String, dynamic> json) => JobOffer(
    id: json['id'],
    title: json['title'],
    companyName: json['companyName'],
    salary: json['salary'],
    requiredEducationLevel: json['requiredEducationLevel'],
    requiredSkills: List<String>.from(json['requiredSkills']),
  );
}
