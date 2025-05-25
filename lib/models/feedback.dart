class Feedback {
  String id;
  final String course;
  final String courseId;
  final String job;
  final String jobId;
  final String userId;
  final String feedback;
  final double rating;

  Feedback({
    required this.id,
    required this.course,
    required this.courseId,
    required this.job,
    required this.jobId,
    required this.userId,
    required this.feedback,
    required this.rating,
  });

  // Factory method to create a Feedback from JSON
  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      course: json['course'],
      courseId: json['courseId'],
      job: json['job'],
      jobId: json['jobId'],
      userId: json['userId'],
      feedback: json['feedback'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  // Method to convert FeedbackModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'courseId': courseId,
      'job': job,
      'jobId': jobId,
      'userId': userId,
      'feedback': feedback,
      'rating': rating,
    };
  }
}