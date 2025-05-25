import 'experience.dart';
import 'education.dart';
import 'Project.dart';
import 'social.dart';
import 'certificate.dart';
import 'address.dart';
import 'course.dart';
import 'progress.dart';

class Profile {
  String id;
  final String userId;
  final String handle;
  final String? company;
  final String? website;
  final String? location;
  final String status; // Designation
  final List<String> skills;
  final String? bio;
  final String? githubUsername;
  final List<Experience>? experience;
  final List<Education>? education;
  final List<Project>? projects;
  final Social social;
  final DateTime date;
  final List<Certificate>? certificates;
  final List<Address>? addresses;
  final List<Course>? enrolledCourses;
  final List<Progress>? courseProgress;
  final List<String>? interests;
  final List<String>? languages;
  final List<String>? hobbies;
  final List<String>? volunteerExperience;
  final List<String>? references;
  final List<String>? awards;
  final List<String>? uploadResumeIds;

  Profile({
    required this.id,
    required this.userId,
    required this.handle,
    this.company,
    this.website,
    this.location,
    required this.status,
    required this.skills,
    this.bio,
    this.githubUsername,
    this.experience,
    this.education,
    this.projects,
    required this.social,
    required this.date,
    this.certificates,
    this.addresses,
    this.enrolledCourses,
    this.courseProgress,
    this.interests,
    this.languages,
    this.hobbies,
    this.volunteerExperience,
    this.references,
    this.awards,
    this.uploadResumeIds,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      handle: json['handle'] ?? '',
      company: json['company'],
      website: json['website'],
      location: json['location'],
      status: json['status'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      bio: json['bio'],
      githubUsername: json['githubUsername'],
      experience: (json['experience'] as List?)
          ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List?)
          ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      social: Social.fromJson(json['social'] as Map<String, dynamic>),
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      certificates: (json['certificates'] as List?)
          ?.map((c) => Certificate.fromJson(c as Map<String, dynamic>))
          .toList(),
      addresses: (json['addresses'] as List?)
          ?.map((a) => Address.fromJson(a as Map<String, dynamic>))
          .toList(),
      enrolledCourses: (json['enrolledCourses'] as List?)
          ?.map((c) => Course.fromJson(c as Map<String, dynamic>))
          .toList(),
      courseProgress: (json['courseProgress'] as List?)
          ?.map((p) => Progress.fromJson(p as Map<String, dynamic>))
          .toList(),
      interests:
          (json['interests'] as List?)?.map((i) => i.toString()).toList(),
      languages:
          (json['languages'] as List?)?.map((l) => l.toString()).toList(),
      hobbies: (json['hobbies'] as List?)?.map((h) => h.toString()).toList(),
      volunteerExperience: (json['volunteerExperience'] as List?)
          ?.map((v) => v.toString())
          .toList(),
      references:
          (json['references'] as List?)?.map((r) => r.toString()).toList(),
      awards: (json['awards'] as List?)?.map((a) => a.toString()).toList(),
      uploadResumeIds:
          (json['uploadResumeIds'] as List?)?.map((u) => u.toString()).toList(),
    );
  }

  get upLoadResumeIds => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'handle': handle,
      'company': company,
      'website': website,
      'location': location,
      'status': status,
      'skills': skills,
      'bio': bio,
      'githubUsername': githubUsername,
      'experience': experience?.map((e) => e.toJson()).toList(),
      'education': education?.map((e) => e.toJson()).toList(),
      'projects': projects?.map((e) => e.toJson()).toList(),
      'social': social.toJson(),
      'date': date.toIso8601String(),
      'certificates': certificates?.map((c) => c.toJson()).toList(),
      'addresses': addresses?.map((a) => a.toJson()).toList(),
      'enrolledCourses': enrolledCourses?.map((c) => c.toJson()).toList(),
      'courseProgress': courseProgress?.map((p) => p.toJson()).toList(),
      'interests': interests,
      'languages': languages,
      'hobbies': hobbies,
      'volunteerExperience': volunteerExperience,
      'references': references,
      'awards': awards,
      'uploadResumeIds': uploadResumeIds,
    };
  }

  Profile copyWith({
    String? id,
    String? userId,
    String? handle,
    String? company,
    String? website,
    String? location,
    String? status,
    List<String>? skills,
    String? bio,
    String? githubUsername,
    List<Experience>? experience,
    List<Education>? education,
    List<Project>? projects,
    Social? social,
    DateTime? date,
    List<Certificate>? certificates,
    List<Address>? addresses,
    List<Course>? enrolledCourses,
    List<Progress>? courseProgress,
    List<String>? interests,
    List<String>? languages,
    List<String>? hobbies,
    List<String>? volunteerExperience,
    List<String>? references,
    List<String>? awards,
    List<String>? uploadResumeIds,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      handle: handle ?? this.handle,
      company: company ?? this.company,
      website: website ?? this.website,
      location: location ?? this.location,
      status: status ?? this.status,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      githubUsername: githubUsername ?? this.githubUsername,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      projects: projects ?? this.projects,
      social: social ?? this.social,
      date: date ?? this.date,
      certificates: certificates ?? this.certificates,
      addresses: addresses ?? this.addresses,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      courseProgress: courseProgress ?? this.courseProgress,
      interests: interests ?? this.interests,
      languages: languages ?? this.languages,
      hobbies: hobbies ?? this.hobbies,
      volunteerExperience: volunteerExperience ?? this.volunteerExperience,
      references: references ?? this.references,
      awards: awards ?? this.awards,
      uploadResumeIds: uploadResumeIds ?? this.uploadResumeIds,
    );
  }
}
