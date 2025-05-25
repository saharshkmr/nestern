class Certificate {
  String id;
  final String name;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expirationDate;
  final String? credentialId;
  final String? credentialUrl;
  final String userId; // Add userId field

  Certificate({
    required this.id,
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expirationDate,
    this.credentialId,
    this.credentialUrl,
    required this.userId, // Add userId to constructor
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] ?? '', // Add null checks
      name: json['name'] ?? '', // Add null checks
      issuingOrganization: json['issuingOrganization'] ?? '', // Add null checks
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : DateTime.now(), // Add null checks and default value
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
      userId: json['userId'] ?? '', // Add userId to fromJson
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuingOrganization': issuingOrganization,
      'issueDate': issueDate.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
      'userId': userId, // Add userId to toJson
    };
  }

  Certificate copyWith({
    String? id,
    String? name,
    String? issuingOrganization,
    DateTime? issueDate,
    DateTime? expirationDate,
    String? credentialId,
    String? credentialUrl,
    String? userId,
  }) {
    return Certificate(
      id: id ?? this.id,
      name: name ?? this.name,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Certificate{id: $id, name: $name, issuingOrganization: $issuingOrganization, issueDate: $issueDate, expirationDate: $expirationDate, credentialId: $credentialId, credentialUrl: $credentialUrl, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Certificate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          issuingOrganization == other.issuingOrganization &&
          issueDate == other.issueDate &&
          expirationDate == other.expirationDate &&
          credentialId == other.credentialId &&
          credentialUrl == other.credentialUrl &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      issuingOrganization.hashCode ^
      issueDate.hashCode ^
      expirationDate.hashCode ^
      credentialId.hashCode ^
      credentialUrl.hashCode ^
      userId.hashCode;
}
