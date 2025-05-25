class Experience {
  String id;
  final String title;
  final String company;
  final String? location;
  final DateTime from;
  final DateTime? to;
  final bool current;
  final String? description;
  final String jobTitle;
  final String jobField;
  final List<String> skill;
  final String userId; // Add userId field

  Experience({
    required this.id,
    required this.title,
    required this.company,
    this.location,
    required this.from,
    required this.jobField,
    this.to,
    required this.current,
    this.description,
    required this.jobTitle,
    required this.skill,
    required this.userId, // Add userId to constructor
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'],
      from:
          json['from'] != null ? DateTime.parse(json['from']) : DateTime.now(),
      to: json['to'] != null ? DateTime.parse(json['to']) : null,
      current: json['current'] ?? false,
      description: json['description'],
      jobField: json['jobField'] ?? '', // ✅ fix
      jobTitle: json['jobTitle'] ?? '',
      skill: List<String>.from(json['skill'] ?? []),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'from': from.toIso8601String(),
      'to': to?.toIso8601String(),
      'current': current,
      'description': description,
      'jobTitle': jobTitle,
      'jobField': jobField,
      'skill': skill,
      'userId': userId, // Add userId to toJson
    };
  }

  Experience copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    DateTime? from,
    DateTime? to,
    bool? current,
    String? description,
    String? jobTitle,
    String? jobField,
    List<String>? skill,
    String? userId,
  }) {
    return Experience(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      from: from ?? this.from,
      to: to ?? this.to,
      current: current ?? this.current,
      description: description ?? this.description,
      jobTitle: jobTitle ?? this.jobTitle,
      jobField: jobField ?? this.jobField,
      skill: skill ?? this.skill,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Experience{id: $id, title: $title, company: $company, location: $location, jobField: $jobField, from: $from, to: $to, current: $current, description: $description, jobTitle: $jobTitle, skill: $skill, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Experience &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          company == other.company &&
          location == other.location &&
          from == other.from &&
          to == other.to &&
          current == other.current &&
          description == other.description &&
          jobTitle == other.jobTitle &&
          jobField == other.jobField &&
          skill == other.skill &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      company.hashCode ^
      location.hashCode ^
      from.hashCode ^
      to.hashCode ^
      current.hashCode ^
      description.hashCode ^
      jobTitle.hashCode ^
      jobField.hashCode ^
      skill.hashCode ^
      userId.hashCode;
}
