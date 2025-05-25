class Project {
  String id;
  final String name;
  final String companyName;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> skills;
  final String role;
  final String? projectDesc;
  final String projectName;
  final String clientName;
  final String userId; // Add userId field

  Project({
    required this.id,
    required this.name,
    required this.companyName,
    required this.startDate,
    this.endDate,
    required this.skills,
    required this.role,
    this.projectDesc,
    required this.projectName,
    required this.clientName,
    required this.userId, // Add userId to constructor
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '', // Add null checks
      name: json['name'] ?? '', // Add null checks
      companyName: json['companyName'] ?? '', // Add null checks
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(), // Add null checks and default value
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      skills: List<String>.from(
          json['skills'] ?? []), // Add null checks and default value
      role: json['role'] ?? '', // Add null checks
      projectDesc: json['projectDesc'],
      projectName: json['projectName'] ?? '', // Add null checks
      clientName: json['clientName'] ?? '', // Add null checks
      userId: json['userId'] ?? '', // Add null checks
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'skills': skills,
      'role': role,
      'projectDesc': projectDesc,
      'projectName': projectName,
      'clientName': clientName,
      'userId': userId, // Add userId to toJson
    };
  }

  Project copyWith({
    String? id,
    String? name,
    String? companyName,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? skills,
    String? role,
    String? projectDesc,
    String? projectName,
    String? clientName,
    String? userId,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      skills: skills ?? this.skills,
      role: role ?? this.role,
      projectDesc: projectDesc ?? this.projectDesc,
      projectName: projectName ?? this.projectName,
      clientName: clientName ?? this.clientName,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Project{id: $id, name: $name, companyName: $companyName, startDate: $startDate, endDate: $endDate, skills: $skills, role: $role, projectDesc: $projectDesc, projectName: $projectName, clientName: $clientName, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          companyName == other.companyName &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          skills == other.skills &&
          role == other.role &&
          projectDesc == other.projectDesc &&
          projectName == other.projectName &&
          clientName == other.clientName &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      companyName.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      skills.hashCode ^
      role.hashCode ^
      projectDesc.hashCode ^
      projectName.hashCode ^
      clientName.hashCode ^
      userId.hashCode;
}
