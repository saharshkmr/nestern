class Topic {
  String id;
  final String courseId;
  final String name;
  final String description;
  final String instructor;
  final String? imageUrl;
  final String? studyVideoUrl; // This will store the complete video URL
  final String? attachment; // This will store document URL and name in format "url|name"
  final String title;
  final List<String> question;
  final String userId;

  Topic({
    required this.id,
    required this.courseId,
    required this.name,
    required this.description,
    required this.instructor,
    this.studyVideoUrl,
    this.imageUrl,
    this.attachment,
    required this.title,
    required this.question,
    required this.userId,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      studyVideoUrl: json['studyVideoUrl'],
      imageUrl: json['imageUrl'],
      attachment: json['attachment'],
      title: json['title'] ?? '',
      question: List<String>.from(
          json['question'] ?? []),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'name': name,
      'description': description,
      'instructor': instructor,
      'imageUrl': imageUrl,
      'studyVideoUrl': studyVideoUrl,
      'attachment': attachment,
      'title': title,
      'question': question,
      'userId': userId,
    };
  }

  // Get document URL and name separately
  String? get documentUrl => attachment?.split('|').first;
  String? get documentName => attachment!.split('|').length > 1 ? attachment?.split('|')[1] : 'Document';

  Topic copyWith({
    String? id,
    String? courseId,
    String? name,
    String? description,
    String? instructor,
    String? imageUrl,
    String? studyVideoUrl,
    String? attachment,
    String? title,
    List<String>? question,
    String? userId,
  }) {
    return Topic(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      studyVideoUrl: studyVideoUrl ?? this.studyVideoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      attachment: attachment ?? this.attachment,
      title: title ?? this.title,
      question: question ?? this.question,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Topic{id: $id, courseId: $courseId, name: $name, description: $description, instructor: $instructor, imageUrl: $imageUrl, studyVideoUrl: $studyVideoUrl, attachment: $attachment, title: $title, question: $question, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Topic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          courseId == other.courseId &&
          name == other.name &&
          description == other.description &&
          instructor == other.instructor &&
          imageUrl == other.imageUrl &&
          studyVideoUrl == other.studyVideoUrl &&
          attachment == other.attachment &&
          title == other.title &&
          question == other.question &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      courseId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      instructor.hashCode ^
      imageUrl.hashCode ^
      studyVideoUrl.hashCode ^
      attachment.hashCode ^
      title.hashCode ^
      question.hashCode ^
      userId.hashCode;
}