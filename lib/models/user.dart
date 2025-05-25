import 'package:cloud_firestore/cloud_firestore.dart';

enum UserStatus { online, away, offline }

class User {
  String id;
  final String company;
  final String profileName;
  final String email;
  final String mobile;
  final String? url;
  final String? uid;
  final String? role;
  final String? bio;
  final bool? isProfileComplete;
  final bool? hasResume;
  final UserStatus? status;
  var experienceRole;
  List<String> skills;
  final bool isOnline;
  final Timestamp? lastSeen;

  // New employer fields
  final String? companyWebsite;
  final String? companyAddress;
  final String? industryType;
  final String? companySize;
  final String? contactPerson;

  User({
    required this.id,
    required this.company,
    required this.profileName,
    required this.email,
    required this.mobile,
    required this.role,
    this.uid,
    this.url,
    this.bio,
    this.isProfileComplete,
    this.hasResume,
    this.status,
    required this.skills,
    this.isOnline = false,
    this.lastSeen,
    this.companyWebsite,
    this.companyAddress,
    this.industryType,
    this.companySize,
    this.contactPerson,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      profileName: json['profileName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      url: json['url'],
      uid: json['uid'],
      bio: json['bio'],
      role: json['role'],
      isProfileComplete: json['isProfileComplete'],
      hasResume: json['hasResume'],
      skills: List<String>.from(json['skills'] ?? []),
      status: json['status'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'],
      companyWebsite: json['companyWebsite'],
      companyAddress: json['companyAddress'],
      industryType: json['industryType'],
      companySize: json['companySize'],
      contactPerson: json['contactPerson'],
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'profileName': profileName,
      'email': email,
      'mobile': mobile,
      'uid': uid,
      'url': url,
      'role': role,
      'bio': bio,
      'isProfileComplete': isProfileComplete,
      'hasResume': hasResume,
      'status': status,
      'skills': skills,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'companyWebsite': companyWebsite,
      'companyAddress': companyAddress,
      'industryType': industryType,
      'companySize': companySize,
      'contactPerson': contactPerson,
    };
  }

  User copyWith({
    String? id,
    String? company,
    String? profileName,
    String? email,
    String? mobile,
    String? uid,
    String? role,
    String? url,
    String? bio,
    bool? isProfileComplete,
    bool? hasResume,
    UserStatus? status,
    bool? isOnline,
    Timestamp? lastSeen,
    List<String>? skills,
    String? companyWebsite,
    String? companyAddress,
    String? industryType,
    String? companySize,
    String? contactPerson,
  }) {
    return User(
      id: id ?? this.id,
      company: company ?? this.company,
      profileName: profileName ?? this.profileName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      url: url ?? this.url,
      bio: bio ?? this.bio,
      uid: uid ?? this.uid,
      role: role ?? this.role,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      hasResume: hasResume ?? this.hasResume,
      status: status ?? this.status,
      skills: skills ?? this.skills,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyAddress: companyAddress ?? this.companyAddress,
      industryType: industryType ?? this.industryType,
      companySize: companySize ?? this.companySize,
      contactPerson: contactPerson ?? this.contactPerson,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, company: $company, role: $role, uid: $uid, profileName: $profileName, email: $email, mobile: $mobile, url: $url, bio: $bio, isProfileComplete: $isProfileComplete, hasResume: $hasResume, status: $status, companyWebsite: $companyWebsite, companyAddress: $companyAddress, industryType: $industryType, companySize: $companySize, contactPerson: $contactPerson}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          uid == other.uid &&
          role == other.role &&
          company == other.company &&
          profileName == other.profileName &&
          email == other.email &&
          mobile == other.mobile &&
          url == other.url &&
          bio == other.bio &&
          isProfileComplete == other.isProfileComplete &&
          hasResume == other.hasResume &&
          status == other.status &&
          skills == other.skills &&
          companyWebsite == other.companyWebsite &&
          companyAddress == other.companyAddress &&
          industryType == other.industryType &&
          companySize == other.companySize &&
          contactPerson == other.contactPerson;

  @override
  int get hashCode =>
      id.hashCode ^
      company.hashCode ^
      uid.hashCode ^
      role.hashCode ^
      profileName.hashCode ^
      email.hashCode ^
      mobile.hashCode ^
      url.hashCode ^
      bio.hashCode ^
      isProfileComplete.hashCode ^
      hasResume.hashCode ^
      status.hashCode ^
      skills.hashCode ^
      companyWebsite.hashCode ^
      companyAddress.hashCode ^
      industryType.hashCode ^
      companySize.hashCode ^
      contactPerson.hashCode;

  List<String> get experiences => [];

  String? get profileImageUrl => null;
}