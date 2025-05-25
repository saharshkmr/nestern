// lib/services/review_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nestern/models/review.dart';

class ReviewService {
  final CollectionReference _reviewsCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('courses')
      .collection('reviews');
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final CollectionReference _notificationsCollection = FirebaseFirestore
      .instance
      .collection('nestern')
      .doc('notifications')
      .collection('userNotifications');

  // Get all reviews for a course with fallback for index building
  Future<List<Review>> getReviewsForCourse(String courseId) async {
    try {
      // Try with ordering first (requires index)
      final querySnapshot = await _reviewsCollection
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error getting reviews for course $courseId: $e');
      
      // If the error is related to index building, try without ordering
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('requires an index')) {
        try {
          debugPrint('Falling back to non-ordered query while index builds...');
          final fallbackSnapshot = await _reviewsCollection
              .where('courseId', isEqualTo: courseId)
              .get();
          
          // Sort the results in memory instead
          final reviews = fallbackSnapshot.docs
              .map((doc) => Review.fromFirestore(doc))
              .toList();
          
          // Sort by createdAt in memory
          reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return reviews;
        } catch (fallbackError) {
          debugPrint('Error with fallback query: $fallbackError');
          return [];
        }
      }
      
      return [];
    }
  }

  // Get top reviews for a course (highest rated) with fallback
  Future<List<Review>> getTopReviewsForCourse(String courseId, int limit) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('courseId', isEqualTo: courseId)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error getting top reviews for course $courseId: $e');
      
      // Fallback if index is building
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('requires an index')) {
        try {
          final fallbackSnapshot = await _reviewsCollection
              .where('courseId', isEqualTo: courseId)
              .get();
          
          final reviews = fallbackSnapshot.docs
              .map((doc) => Review.fromFirestore(doc))
              .toList();
          
          // Sort by rating in memory
          reviews.sort((a, b) => b.rating.compareTo(a.rating));
          
          // Apply limit in memory
          return reviews.take(limit).toList();
        } catch (fallbackError) {
          debugPrint('Error with fallback query: $fallbackError');
          return [];
        }
      }
      
      return [];
    }
  }

  // Get reviews by a specific user with fallback
  Future<List<Review>> getReviewsByUser(String userId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error getting reviews by user $userId: $e');
      
      // Fallback if index is building
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('requires an index')) {
        try {
          final fallbackSnapshot = await _reviewsCollection
              .where('userId', isEqualTo: userId)
              .get();
          
          final reviews = fallbackSnapshot.docs
              .map((doc) => Review.fromFirestore(doc))
              .toList();
          
          // Sort by createdAt in memory
          reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return reviews;
        } catch (fallbackError) {
          debugPrint('Error with fallback query: $fallbackError');
          return [];
        }
      }
      
      return [];
    }
  }

  // Create a new review - fixed to ensure document paths are valid
  Future<String> createReview(Review review) async {
    try {
      // Validate required fields
      if (review.courseId.isEmpty) {
        throw ArgumentError('Course ID cannot be empty');
      }
      if (review.userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      // Check if user has already reviewed this course
      final existingReview = await getUserReviewForCourse(review.userId, review.courseId);
      if (existingReview != null) {
        // Update existing review instead of creating a new one
        await updateReview(
          existingReview.id,
          rating: review.rating,
          content: review.content,
        );
        return existingReview.id;
      }

      // Create new review
      final reviewData = review.toFirestore();
      final docRef = await _reviewsCollection.add(reviewData);
      
      try {
        // Create notification for course creator - wrapped in try/catch to prevent failure
        await _createReviewNotification(review);
      } catch (notificationError) {
        debugPrint('Error creating notification, but review was saved: $notificationError');
      }
      
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating review: $e');
      throw e;
    }
  }

  // Add a new review (alternative method signature) - with validation
  Future<Review?> addReview({
    required String userId,
    required String userName,
    required String courseId,
    required int rating,
    required String content,
    String? userImage,
    bool isVerifiedPurchase = false,
  }) async {
    try {
      // Validate required fields
      if (courseId.isEmpty) {
        throw ArgumentError('Course ID cannot be empty');
      }
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      // Check if user has already reviewed this course
      final existingReview = await getUserReviewForCourse(userId, courseId);
      if (existingReview != null) {
        // Update existing review instead of creating a new one
        return await updateReview(
          existingReview.id,
          rating: rating,
          content: content,
        );
      }

      // Create new review
      final review = Review(
        id: '',
        userId: userId,
        userName: userName,
        userProfileUrl: userImage ?? '',
        courseId: courseId,
        rating: rating,
        content: content,
        createdAt: DateTime.now(),
        isVerifiedPurchase: isVerifiedPurchase,
      );

      final docRef = await _reviewsCollection.add(review.toFirestore());
      
      try {
        // Create notification for course creator
        await _createReviewNotification(review);
      } catch (notificationError) {
        debugPrint('Error creating notification, but review was saved: $notificationError');
      }
      
      // Fetch the newly created review
      final docSnapshot = await docRef.get();
      return Review.fromFirestore(docSnapshot);
    } catch (e) {
      debugPrint('Error adding review: $e');
      return null;
    }
  }

  // Create notification for course creator when a review is posted - with error handling
  Future<void> _createReviewNotification(Review review) async {
    try {
      // Validate courseId
      if (review.courseId.isEmpty) {
        debugPrint('Cannot create notification: Course ID is empty');
        return;
      }
      
      // Get course creator ID
      final courseDoc = await _firestore
          .collection('nestern')
          .doc('courses')
          .collection('listings')
          .doc(review.courseId)
          .get();
      
      if (!courseDoc.exists) {
        debugPrint('Course document does not exist for ID: ${review.courseId}');
        return;
      }
      
      final creatorId = courseDoc.data()?['createrId'] ?? courseDoc.data()?['userId'];
      if (creatorId == null || creatorId.toString().isEmpty) {
        debugPrint('Creator ID is null or empty for course: ${review.courseId}');
        return;
      }
      
      // Create notification
      await _notificationsCollection.add({
        'userId': creatorId,
        'type': 'review',
        'title': 'New Review',
        'message': '${review.userName} left a ${review.rating}-star review on your course',
        'relatedId': review.courseId,
        'createdAt': Timestamp.now(),
        'isRead': false,
      });
    } catch (e) {
      debugPrint('Error creating review notification: $e');
      // Don't rethrow - notification failure shouldn't break review creation
    }
  }

  // Rest of the methods remain the same...
  // Update an existing review
  Future<Review?> updateReview(
    String reviewId, {
    int? rating,
    String? content,
  }) async {
    try {
      final reviewRef = _reviewsCollection.doc(reviewId);
      final reviewSnapshot = await reviewRef.get();
      
      if (!reviewSnapshot.exists) {
        debugPrint('Review $reviewId does not exist');
        return null;
      }
      
      final updateData = <String, dynamic>{};
      if (rating != null) updateData['rating'] = rating;
      if (content != null) updateData['content'] = content;
      updateData['updatedAt'] = Timestamp.now();
      
      await reviewRef.update(updateData);
      
      // Fetch the updated review
      final updatedSnapshot = await reviewRef.get();
      return Review.fromFirestore(updatedSnapshot);
    } catch (e) {
      debugPrint('Error updating review $reviewId: $e');
      return null;
    }
  }

  // Delete a review
  Future<bool> deleteReview(String reviewId) async {
    try {
      await _reviewsCollection.doc(reviewId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting review $reviewId: $e');
      return false;
    }
  }

  // Get a review by ID
  Future<Review?> getReviewById(String reviewId) async {
    try {
      final docSnapshot = await _reviewsCollection.doc(reviewId).get();
      
      if (!docSnapshot.exists) {
        return null;
      }
      
      return Review.fromFirestore(docSnapshot);
    } catch (e) {
      debugPrint('Error getting review $reviewId: $e');
      return null;
    }
  }

  // Check if a user has already reviewed a course - with fallback for index issues
  Future<Review?> getUserReviewForCourse(String userId, String courseId) async {
    try {
      // Validate inputs
      if (userId.isEmpty || courseId.isEmpty) {
        debugPrint('getUserReviewForCourse: userId or courseId is empty');
        return null;
      }
      
      final querySnapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      
      return Review.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      debugPrint('Error checking if user $userId has reviewed course $courseId: $e');
      
      // If the error is related to index building, try a different approach
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('requires an index')) {
        try {
          // Get all reviews by this user (should be fewer)
          final userReviews = await _reviewsCollection
              .where('userId', isEqualTo: userId)
              .get();
          
          // Filter in memory
          for (final doc in userReviews.docs) {
            final review = Review.fromFirestore(doc);
            if (review.courseId == courseId) {
              return review;
            }
          }
          return null;
        } catch (fallbackError) {
          debugPrint('Error with fallback query: $fallbackError');
          return null;
        }
      }
      
      return null;
    }
  }

  // Get the average rating for a course
  Future<double> getAverageRatingForCourse(String courseId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('courseId', isEqualTo: courseId)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return 0.0;
      }
      
      final reviews = querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
      int totalRating = 0;
      
      for (final review in reviews) {
        totalRating += review.rating;
      }
      
      return totalRating / reviews.length;
    } catch (e) {
      debugPrint('Error getting average rating for course $courseId: $e');
      return 0.0;
    }
  }

  // Get review count for a course
  Future<int> getReviewCountForCourse(String courseId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('courseId', isEqualTo: courseId)
          .get();
      
      return querySnapshot.docs.length;
    } catch (e) {
      debugPrint('Error getting review count for course $courseId: $e');
      return 0;
    }
  }

  // Get rating distribution for a course (e.g., how many 5-star, 4-star, etc.)
  Future<Map<int, int>> getRatingDistributionForCourse(String courseId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('courseId', isEqualTo: courseId)
          .get();
      
      final Map<int, int> distribution = {
        5: 0,
        4: 0,
        3: 0,
        2: 0,
        1: 0,
      };
      
      for (final doc in querySnapshot.docs) {
        final review = Review.fromFirestore(doc);
        if (review.rating >= 1 && review.rating <= 5) {
          distribution[review.rating] = distribution[review.rating]! + 1;
        }
      }
      
      return distribution;
    } catch (e) {
      debugPrint('Error getting rating distribution for course $courseId: $e');
      return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    }
  }
  
  // Get filtered reviews for a course - with fallback for index issues
  Future<List<Review>> getFilteredReviewsForCourse(
    String courseId, {
    String? sortBy, // 'rating_high', 'rating_low', 'newest', 'oldest'
    int? minRating,
    int? maxRating,
    bool? verifiedOnly,
  }) async {
    try {
      Query query = _reviewsCollection.where('courseId', isEqualTo: courseId);
      
      // Apply rating filters
      if (minRating != null) {
        query = query.where('rating', isGreaterThanOrEqualTo: minRating);
      }
      if (maxRating != null) {
        query = query.where('rating', isLessThanOrEqualTo: maxRating);
      }
      
      // Apply verified purchase filter
      if (verifiedOnly == true) {
        query = query.where('isVerifiedPurchase', isEqualTo: true);
      }
      
      // Apply sorting
      if (sortBy != null) {
        switch (sortBy) {
          case 'rating_high':
            query = query.orderBy('rating', descending: true);
            break;
          case 'rating_low':
            query = query.orderBy('rating', descending: false);
            break;
          case 'newest':
            query = query.orderBy('createdAt', descending: true);
            break;
          case 'oldest':
            query = query.orderBy('createdAt', descending: false);
            break;
        }
      } else {
        // Default sorting by newest
        query = query.orderBy('createdAt', descending: true);
      }
      
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error getting filtered reviews for course $courseId: $e');
      
      // Fallback if index is building
      if (e.toString().contains('failed-precondition') || 
          e.toString().contains('requires an index')) {
        try {
          // Get all reviews for the course without ordering
          Query query = _reviewsCollection.where('courseId', isEqualTo: courseId);
          
          final querySnapshot = await query.get();
          List<Review> reviews = querySnapshot.docs
              .map((doc) => Review.fromFirestore(doc))
              .toList();
          
          // Apply filters in memory
          if (minRating != null) {
            reviews = reviews.where((r) => r.rating >= minRating).toList();
          }
          if (maxRating != null) {
            reviews = reviews.where((r) => r.rating <= maxRating).toList();
          }
          if (verifiedOnly == true) {
            reviews = reviews.where((r) => r.isVerifiedPurchase).toList();
          }
          
          // Apply sorting in memory
          if (sortBy != null) {
            switch (sortBy) {
              case 'rating_high':
                reviews.sort((a, b) => b.rating.compareTo(a.rating));
                break;
              case 'rating_low':
                reviews.sort((a, b) => a.rating.compareTo(b.rating));
                break;
              case 'newest':
                reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                break;
              case 'oldest':
                reviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                break;
            }
          } else {
            // Default sorting by newest
            reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          }
          
          return reviews;
        } catch (fallbackError) {
          debugPrint('Error with fallback query: $fallbackError');
          return [];
        }
      }
      
      return [];
    }
  }
}