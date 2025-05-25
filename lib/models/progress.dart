class Progress {
  String id;
  final String userId;
  final String courseId;
  final double percentageCompleted;
  final DateTime lastAccessDate;

  Progress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.percentageCompleted,
    required this.lastAccessDate,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] ?? '', // Add null checks
      userId: json['userId'] ?? '', // Add null checks
      courseId: json['courseId'] ?? '', // Add null checks
      percentageCompleted: (json['percentageCompleted'] as num?)?.toDouble() ??
          0.0, // Add null checks and default value
      lastAccessDate: json['lastAccessDate'] != null
          ? DateTime.parse(json['lastAccessDate'])
          : DateTime.now(), // Add null checks and default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'percentageCompleted': percentageCompleted,
      'lastAccessDate': lastAccessDate.toIso8601String(),
    };
  }

  Progress copyWith({
    String? id,
    String? userId,
    String? courseId,
    double? percentageCompleted,
    DateTime? lastAccessDate,
  }) {
    return Progress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      percentageCompleted: percentageCompleted ?? this.percentageCompleted,
      lastAccessDate: lastAccessDate ?? this.lastAccessDate,
    );
  }

  @override
  String toString() {
    return 'Progress{id: $id, userId: $userId, courseId: $courseId, percentageCompleted: $percentageCompleted, lastAccessDate: $lastAccessDate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Progress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          courseId == other.courseId &&
          percentageCompleted == other.percentageCompleted &&
          lastAccessDate == other.lastAccessDate;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      courseId.hashCode ^
      percentageCompleted.hashCode ^
      lastAccessDate.hashCode;
}
