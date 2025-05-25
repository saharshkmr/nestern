import 'package:flutter/material.dart';
import 'package:nestern/models/topic.dart';

class Course {
  String id;
  final String title;//1
  final String description;
  final List<String> category;//2
  final List<String> skill;
  final String instructorName;
  final String instructorUrl;
  final List<Topic> topics;
  final String duration;//3
  final String level;//4
  final String location;//5
  final String? mode;//6
  final double price;//7
  final String url;
  final DateTime? startDate;//8
  final DateTime? endDate;//9
  final String status;//10
  final String? createrId;
  final String userId;

  final String courseMode; // e.g., "Online" or "Offline"
  final String teachingMode; // e.g., "Self-paced" or "Instructor-led"
  DateTime? createdAt;
  DateTime? updatedAt;
  final int applyClickCount;

  // New fields added previously:
  final List<String> accessDevices;       // e.g., ["Laptop", "Mobile", "Tablet"]
  final List<String> certificatePlatforms; // e.g., ["LinkedIn", "Naukri"]
  final String companyProfile;             // Information about the company offering the course
  
  // New display fields for course details
  final String backgroundFit;      // How your background fits this course
  final String tailorLearningPlan; // Tailor my learning plan
  final String goodFit;            // Am I a good fit?
  final String connectWith;        // People you can connect with
  final String teachingTeam;       // Meet the teaching team
  
  // Additional fields as requested:
  final String profileName;        // Profile name
  final String imageUrl;           // Image URL
  final String uid;                // User ID

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.skill,
    required this.instructorName,
    required this.instructorUrl,
    required this.topics,
    required this.location,
    required this.mode,
    required this.duration,
    required this.level,
    required this.price,
    required this.url,
    this.startDate,
    this.endDate,
    required this.status,
    required this.createrId,
    required this.userId,
    required this.courseMode,
    required this.teachingMode,
    this.createdAt,
    this.updatedAt,
    this.applyClickCount = 0,
    // Previously added fields:
    required this.accessDevices,
    required this.certificatePlatforms,
    required this.companyProfile,
    required this.backgroundFit,
    required this.tailorLearningPlan,
    required this.goodFit,
    required this.connectWith,
    required this.teachingTeam,
    // New fields:
    required this.profileName,
    required this.imageUrl,
    required this.uid,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    List<Topic> topicsList = [];
    if (json['topics'] is List) {
      topicsList = (json['topics'] as List).map((item) {
        if (item is Map<String, dynamic>) {
          return Topic.fromJson(item);
        }
        // If item is not a Map, we ignore it (or you can handle it differently)
        return null;
      }).whereType<Topic>().toList();
    }
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: List<String>.from(json['category'] ?? []),
      skill: List<String>.from(json['skill'] ?? []),
      instructorName: json['instructorName'] ?? '',
      instructorUrl: json['instructorUrl'] ?? '',
      topics: topicsList,
      location: json['location'] ?? '',
      mode: json['mode'] ?? '',
      duration: json['duration'] ?? '',
      level: json['level'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      url: json['url'] ?? '',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'] ?? '',
      createrId: json['createrId'],
      userId: json['userId'] ?? '',
      courseMode: json['courseMode'] ?? 'Online',
      teachingMode: json['teachingMode'] ?? 'Instructor-led',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      applyClickCount: json['applyClickCount'] ?? 0,
      // Previously added fields:
      accessDevices: List<String>.from(json['accessDevices'] ?? []),
      certificatePlatforms: List<String>.from(json['certificatePlatforms'] ?? []),
      companyProfile: json['companyProfile'] ?? '',
      backgroundFit: json['backgroundFit'] ?? '',
      tailorLearningPlan: json['tailorLearningPlan'] ?? '',
      goodFit: json['goodFit'] ?? '',
      connectWith: json['connectWith'] ?? '',
      teachingTeam: json['teachingTeam'] ?? '',
      // New fields:
      profileName: json['profileName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      uid: json['uid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'skill': skill,
      'instructorName': instructorName,
      'instructorUrl': instructorUrl,
      'topics': topics.map((topic) => topic.toJson()).toList(),
      'duration': duration,
      'location': location,
      'mode': mode,
      'level': level,
      'price': price,
      'url': url,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'createrId': createrId,
      'userId': userId,
      'courseMode': courseMode,
      'teachingMode': teachingMode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'applyClickCount': applyClickCount,
      // Previously added fields:
      'accessDevices': accessDevices,
      'certificatePlatforms': certificatePlatforms,
      'companyProfile': companyProfile,
      'backgroundFit': backgroundFit,
      'tailorLearningPlan': tailorLearningPlan,
      'goodFit': goodFit,
      'connectWith': connectWith,
      'teachingTeam': teachingTeam,
      // New fields:
      'profileName': profileName,
      'imageUrl': imageUrl,
      'uid': uid,
    };
  }

  Course copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? category,
    List<String>? skill,
    String? instructorName,
    String? instructorUrl,
    List<Topic>? topics,
    String? duration,
    String? level,
    String? location,
    String? mode,
    double? price,
    String? url,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? createrId,
    String? userId,
    String? courseMode,
    String? teachingMode,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? applyClickCount,
    // Previously added optional parameters:
    List<String>? accessDevices,
    List<String>? certificatePlatforms,
    String? companyProfile,
    String? backgroundFit,
    String? tailorLearningPlan,
    String? goodFit,
    String? connectWith,
    String? teachingTeam,
    // New optional parameters:
    String? profileName,
    String? imageUrl,
    String? uid,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      skill: skill ?? this.skill,
      instructorName: instructorName ?? this.instructorName,
      instructorUrl: instructorUrl ?? this.instructorUrl,
      topics: topics ?? this.topics,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      location: location ?? this.location,
      mode: mode ?? this.mode,
      price: price ?? this.price,
      url: url ?? this.url,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createrId: createrId ?? this.createrId,
      userId: userId ?? this.userId,
      courseMode: courseMode ?? this.courseMode,
      teachingMode: teachingMode ?? this.teachingMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      applyClickCount: applyClickCount ?? this.applyClickCount,
      // Previously added fields:
      accessDevices: accessDevices ?? this.accessDevices,
      certificatePlatforms: certificatePlatforms ?? this.certificatePlatforms,
      companyProfile: companyProfile ?? this.companyProfile,
      backgroundFit: backgroundFit ?? this.backgroundFit,
      tailorLearningPlan: tailorLearningPlan ?? this.tailorLearningPlan,
      goodFit: goodFit ?? this.goodFit,
      connectWith: connectWith ?? this.connectWith,
      teachingTeam: teachingTeam ?? this.teachingTeam,
      // New fields:
      profileName: profileName ?? this.profileName,
      imageUrl: imageUrl ?? this.imageUrl,
      uid: uid ?? this.uid,
    );
  }

  @override
  String toString() {
    return 'Course{id: $id, title: $title, description: $description, category: $category, skill: $skill, instructorName: $instructorName, instructorUrl: $instructorUrl, location: $location, mode: $mode, topics: $topics, duration: $duration, level: $level, price: $price, url: $url, startDate: $startDate, endDate: $endDate, status: $status, createrId: $createrId, userId: $userId, courseMode: $courseMode, teachingMode: $teachingMode, createdAt: $createdAt, updatedAt: $updatedAt, applyClickCount: $applyClickCount, accessDevices: $accessDevices, certificatePlatforms: $certificatePlatforms, companyProfile: $companyProfile, backgroundFit: $backgroundFit, tailorLearningPlan: $tailorLearningPlan, goodFit: $goodFit, connectWith: $connectWith, teachingTeam: $teachingTeam, profileName: $profileName, imageUrl: $imageUrl, uid: $uid}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          category == other.category &&
          skill == other.skill &&
          location == other.location &&
          mode == other.mode &&
          instructorName == other.instructorName &&
          instructorUrl == other.instructorUrl &&
          topics == other.topics &&
          duration == other.duration &&
          level == other.level &&
          price == other.price &&
          url == other.url &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          status == other.status &&
          createrId == other.createrId &&
          userId == other.userId &&
          courseMode == other.courseMode &&
          teachingMode == other.teachingMode &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          applyClickCount == other.applyClickCount &&
          accessDevices == other.accessDevices &&
          certificatePlatforms == other.certificatePlatforms &&
          companyProfile == other.companyProfile &&
          backgroundFit == other.backgroundFit &&
          tailorLearningPlan == other.tailorLearningPlan &&
          goodFit == other.goodFit &&
          connectWith == other.connectWith &&
          teachingTeam == other.teachingTeam &&
          profileName == other.profileName &&
          imageUrl == other.imageUrl &&
          uid == other.uid;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      skill.hashCode ^
      instructorName.hashCode ^
      instructorUrl.hashCode ^
      topics.hashCode ^
      duration.hashCode ^
      level.hashCode ^
      location.hashCode ^
      mode.hashCode ^
      price.hashCode ^
      url.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      status.hashCode ^
      createrId.hashCode ^
      userId.hashCode ^
      courseMode.hashCode ^
      teachingMode.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      applyClickCount.hashCode ^
      accessDevices.hashCode ^
      certificatePlatforms.hashCode ^
      companyProfile.hashCode ^
      backgroundFit.hashCode ^
      tailorLearningPlan.hashCode ^
      goodFit.hashCode ^
      connectWith.hashCode ^
      teachingTeam.hashCode ^
      profileName.hashCode ^
      imageUrl.hashCode ^
      uid.hashCode;
}