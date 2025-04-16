class Employee {
  final String id; // Unique identifier for the user
  final String employeeId; // Unique identifier for the employee
  final String profileName; // Employee's name
  final String email; // Employee's email
  final String mobile; // Employee's mobile number
  final String company; // Company name where the employee works
  final String? designation; // Employee's designation (optional)
  final String? bio; // Employee's bio or description (optional)
  final String? url; // Profile image URL (optional)
  final bool? isProfileComplete; // Whether the profile is complete (optional)
  final List<dynamic>? experiences; // List of work experiences (optional)

  Employee({
    required this.id,
    required this.employeeId,
    required this.profileName,
    required this.email,
    required this.mobile,
    required this.company,
    this.designation,
    this.bio,
    this.url,
    this.isProfileComplete,
    this.experiences,
  });

  // Method to convert an `Employee` object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'profileName': profileName,
      'email': email,
      'mobile': mobile,
      'company': company,
      'designation': designation,
      'bio': bio,
      'url': url,
      'isProfileComplete': isProfileComplete,
      'experiences': experiences,
    };
  }

  // Factory method to create an `Employee` object from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      profileName: json['profileName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      company: json['company'] ?? '',
      designation: json['designation'],
      bio: json['bio'],
      url: json['url'],
      isProfileComplete: json['isProfileComplete'],
      experiences: json['experiences'] ?? [],
    );
  }

  // Method to create a copy of the `Employee` object with updated fields
  Employee copyWith({
    String? id,
    String? employeeId,
    String? profileName,
    String? email,
    String? mobile,
    String? company,
    String? designation,
    String? bio,
    String? url,
    bool? isProfileComplete,
    List<dynamic>? experiences,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      profileName: profileName ?? this.profileName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      company: company ?? this.company,
      designation: designation ?? this.designation,
      bio: bio ?? this.bio,
      url: url ?? this.url,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      experiences: experiences ?? this.experiences,
    );
  }

  @override
  String toString() {
    return 'Employee{id: $id, employeeId: $employeeId, profileName: $profileName, email: $email, mobile: $mobile, company: $company, designation: $designation, bio: $bio, url: $url, isProfileComplete: $isProfileComplete, experiences: $experiences}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          employeeId == other.employeeId &&
          profileName == other.profileName &&
          email == other.email &&
          mobile == other.mobile &&
          company == other.company &&
          designation == other.designation &&
          bio == other.bio &&
          url == other.url &&
          isProfileComplete == other.isProfileComplete &&
          experiences == other.experiences;

  @override
  int get hashCode =>
      id.hashCode ^
      employeeId.hashCode ^
      profileName.hashCode ^
      email.hashCode ^
      mobile.hashCode ^
      company.hashCode ^
      designation.hashCode ^
      bio.hashCode ^
      url.hashCode ^
      isProfileComplete.hashCode ^
      experiences.hashCode;
}