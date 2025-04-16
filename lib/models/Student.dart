class Student {
  final String id; // Unique identifier for the user
  final String studentId; // Unique identifier for the student
  final String profileName; // Student's name
  final String email; // Student's email
  final String mobile; // Student's mobile number
  final String? bio; // Student's bio or description (optional)
  final String? url; // Profile image URL (optional)
  final bool? isProfileComplete; // Whether the profile is complete (optional)
  final bool? hasResume; // Whether the student has uploaded a resume (optional)

  Student({
    required this.id,
    required this.studentId,
    required this.profileName,
    required this.email,
    required this.mobile,
    this.bio,
    this.url,
    this.isProfileComplete,
    this.hasResume,
  });

  // Method to convert a `Student` object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'profileName': profileName,
      'email': email,
      'mobile': mobile,
      'bio': bio,
      'url': url,
      'isProfileComplete': isProfileComplete,
      'hasResume': hasResume,
      'role': 'student', // Role-specific field
    };
  }

  // Factory method to create a `Student` object from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      profileName: json['profileName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      bio: json['bio'],
      url: json['url'],
      isProfileComplete: json['isProfileComplete'],
      hasResume: json['hasResume'],
    );
  }

  // Method to create a copy of the `Student` object with updated fields
  Student copyWith({
    String? id,
    String? studentId,
    String? profileName,
    String? email,
    String? mobile,
    String? bio,
    String? url,
    bool? isProfileComplete,
    bool? hasResume,
  }) {
    return Student(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      profileName: profileName ?? this.profileName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      bio: bio ?? this.bio,
      url: url ?? this.url,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      hasResume: hasResume ?? this.hasResume,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, studentId: $studentId, profileName: $profileName, email: $email, mobile: $mobile, bio: $bio, url: $url, isProfileComplete: $isProfileComplete, hasResume: $hasResume}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          studentId == other.studentId &&
          profileName == other.profileName &&
          email == other.email &&
          mobile == other.mobile &&
          bio == other.bio &&
          url == other.url &&
          isProfileComplete == other.isProfileComplete &&
          hasResume == other.hasResume;

  @override
  int get hashCode =>
      id.hashCode ^
      studentId.hashCode ^
      profileName.hashCode ^
      email.hashCode ^
      mobile.hashCode ^
      bio.hashCode ^
      url.hashCode ^
      isProfileComplete.hashCode ^
      hasResume.hashCode;
}