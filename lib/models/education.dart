class Education {
  String id;
  final String school;
  final String degree;
  final String fieldOfStudy;
  final DateTime from;
  final DateTime? to;
  final bool current;
  final String? description;
  final String userId; // Add userId field

  Education({
    required this.id,
    required this.school,
    required this.degree,
    required this.fieldOfStudy,
    required this.from,
    this.to,
    required this.current,
    this.description,
    required this.userId, // Add userId to constructor
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '', // Add null checks
      school: json['school'] ?? '', // Add null checks
      degree: json['degree'] ?? '', // Add null checks
      fieldOfStudy: json['fieldOfStudy'] ?? '', // Add null checks
      from: json['from'] != null
          ? DateTime.parse(json['from'])
          : DateTime.now(), // Add null checks and default value
      to: json['to'] != null ? DateTime.parse(json['to']) : null,
      current: json['current'] ?? false, // Add null checks and default value
      description: json['description'],
      userId: json['userId'] ?? '', // Add userId to fromJson
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school': school,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'from': from.toIso8601String(),
      'to': to?.toIso8601String(),
      'current': current,
      'description': description,
      'userId': userId, // Add userId to toJson
    };
  }

  Education copyWith({
    String? id,
    String? school,
    String? degree,
    String? fieldOfStudy,
    DateTime? from,
    DateTime? to,
    bool? current,
    String? description,
    String? userId,
  }) {
    return Education(
      id: id ?? this.id,
      school: school ?? this.school,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      from: from ?? this.from,
      to: to ?? this.to,
      current: current ?? this.current,
      description: description ?? this.description,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Education{id: $id, school: $school, degree: $degree, fieldOfStudy: $fieldOfStudy, from: $from, to: $to, current: $current, description: $description, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Education &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          school == other.school &&
          degree == other.degree &&
          fieldOfStudy == other.fieldOfStudy &&
          from == other.from &&
          to == other.to &&
          current == other.current &&
          description == other.description &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      school.hashCode ^
      degree.hashCode ^
      fieldOfStudy.hashCode ^
      from.hashCode ^
      to.hashCode ^
      current.hashCode ^
      description.hashCode ^
      userId.hashCode;
}
