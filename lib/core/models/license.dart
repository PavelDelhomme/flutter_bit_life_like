enum LicenseType {
  driving,
  gun,
  business,
  fishing,
  pilot,
  medical,
}


class License {
  final LicenseType type;
  final DateTime issuedDate;
  final DateTime expirationDate;
  bool isRevoked;
  bool isFake;

  License({
    required this.type,
    required this.issuedDate,
    required this.expirationDate,
    this.isRevoked = false,
    this.isFake = false,
  });

  bool get isExpired => DateTime.now().isAfter(expirationDate);

  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'issuedDate': issuedDate.toIso8601String(),
    'expirationDate': expirationDate.toIso8601String(),
    'isRevoked': isRevoked,
    'isFake': isFake,
  };

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      type: LicenseType.values.firstWhere((e) => e.toString() == json['type']),
      issuedDate: DateTime.parse(json['issuedDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      isRevoked: json['isRevoked'],
      isFake: json['isFake'],
    );
  }
}