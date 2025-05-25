class Report {
  String id;
  final String course;
  final String courseId;
  final String job;
  final String jobId;
  final String userId;
  final String reportContent;

  Report({
    required this.id,
    required this.course,
    required this.courseId,
    required this.job,
    required this.jobId,
    required this.userId,
    required this.reportContent,
  });

  // Factory method to create a Report from JSON
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      course: json['course'],
      courseId: json['courseId'],
      job: json['job'],
      jobId: json['jobId'],
      userId: json['userId'],
      reportContent: json['Report']
    );
  }

  // Method to convert ReportModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'courseId': courseId,
      'job': job,
      'jobId': jobId,
      'userId': userId,
      'reportContent': reportContent,
    };
  }
}