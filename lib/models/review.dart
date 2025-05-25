// lib/models/review.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userProfileUrl; // New field for user profile image URL
  final String courseId;
  final int rating;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerifiedPurchase;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileUrl, // Optional field
    required this.courseId,
    required this.rating,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isVerifiedPurchase = false,
  });

  // Create a Review from a Firestore document
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userProfileUrl: data['userProfileUrl'], // May be null
      courseId: data['courseId'] ?? '',
      rating: data['rating'] ?? 0,
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isVerifiedPurchase: data['isVerifiedPurchase'] ?? false,
    );
  }

  // Convert this Review to a Map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl, // Include even if null
      'courseId': courseId,
      'rating': rating,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isVerifiedPurchase': isVerifiedPurchase,
    };
  }

  // Create a copy of this Review with updated fields
  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileUrl,
    String? courseId,
    int? rating,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerifiedPurchase,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileUrl: userProfileUrl ?? this.userProfileUrl,
      courseId: courseId ?? this.courseId,
      rating: rating ?? this.rating,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
    );
  }
}