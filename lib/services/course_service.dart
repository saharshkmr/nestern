import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/course.dart';
import 'package:nestern/models/feedback.dart';
import 'package:nestern/models/notification.dart';
import 'package:nestern/models/report.dart' as custom_report;
import 'package:nestern/models/topic.dart';
import 'package:nestern/services/notification_service.dart';

class CourseService {
  final CollectionReference _coursesCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('courses')
      .collection('listings');
  final CollectionReference _topicsCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('courses')
      .collection('topics');

  final CollectionReference _coursesfeedbackCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('courses')
      .collection('coursesfeedback');

  final CollectionReference _coursesreportCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('courses')
      .collection('coursesreport');

  // Existing methods and properties

  /// Method to create a course report
  // Future<String> createCourseReport(custom_report.Report report) async {
  //   try {
  //     final docRef = FirebaseFirestore.instance
  //         .collection('nestern')
  //         .doc('reports')
  //         .collection('courseReports')
  //         .doc();

  //     await docRef.set(report.toJson());
  //     return docRef.id;
  //   } catch (e) {
  //     print('Error creating course report: $e');
  //     throw Exception('Failed to create course report');
  //   }
  // }
  // existing methods...

  Future<int> getOngoingCoursesCount(String userId) async {
    // TODO: Replace with actual logic to fetch ongoing courses count for the user
    // For now, return a dummy value
    return 0;
  }

  Future<String> createCourseReport(custom_report.Report report) async {
  try {
    // Add the report to the course reports collection
    DocumentReference docRef = await _coursesreportCollection.add(report.toJson());
    report.id = docRef.id; // Set the report ID to the document ID
    await docRef.set(report.toJson());
    return docRef.id;
  } on FirebaseException catch (e) {
    print('Firebase Exception creating course report: ${e.code} - ${e.message}');
    rethrow;
  } catch (e) {
    print('Error creating course report: $e');
    rethrow;
  }
}


Future<String> createCoursesFeedback(Feedback feedback) async {
  try {
    // Add the feedback to the job feedback collection
    DocumentReference docRef = await _coursesfeedbackCollection.add(feedback.toJson());
    feedback.id = docRef.id; // Set the feedback ID to the document ID
    await docRef.set(feedback.toJson());
    return docRef.id;
  } on FirebaseException catch (e) {
    print('Firebase Exception creating job feedback: ${e.code} - ${e.message}');
    rethrow;
  } catch (e) {
    print('Error creating job feedback: $e');
    rethrow;
  }
}

  Future<String> createCourse(Course course) async {
    // Set timestamp fields on the new course
    final now = DateTime.now();
    course.createdAt = now;
    course.updatedAt = now;

    DocumentReference docRef = await _coursesCollection.add(course.toJson());
    course.id = docRef.id; // Set the course ID to the document ID

    // Save the course with its ID and timestamps
    await docRef.set(course.toJson());
    return docRef.id;
  }

  Future<Course?> getCourse(String courseId) async {
    DocumentSnapshot doc = await _coursesCollection.doc(courseId).get();
    return doc.exists
        ? Course.fromJson(doc.data() as Map<String, dynamic>)
        : null;
  }

  Future<List<Course>> getAllCourses() async {
    try {
      QuerySnapshot snapshot = await _coursesCollection.get();
      return snapshot.docs
          .map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              return Course.fromJson(data);
            } catch (e) {
              print('Error parsing course document ${doc.id}: $e');
              return null;
            }
          })
          .where((course) => course != null)
          .cast<Course>()
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception loading courses: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error loading courses: $e');
      return [];
    }
  }

  // New method to get a real-time stream of courses.
  Stream<List<Course>> getCoursesStream() {
    return _coursesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Course.fromJson(data);
        } catch (e) {
          print('Error parsing course document ${doc.id}: $e');
          return null;
        }
      }).where((course) => course != null).cast<Course>().toList();
    });
  }

  Future<void> updateCourse(Course course, Course oldCourse) async {
    // Update the updatedAt timestamp
    course.updatedAt = DateTime.now();
    await _coursesCollection.doc(course.id).update(course.toJson());

    // Only notify if there are changes compared to the old course
    if (course != oldCourse) {
      NotificationService notificationService = NotificationService();
      Notification notification = Notification(
        id: '',
        type: 'Course Updated',
        content: 'Course ${course.title} has been updated.',
        senderId: course.userId,
        recipientId: 'all', // Or implement a way to notify relevant users
        timestamp: DateTime.now(),
      );
      await notificationService.createNotification(notification);
    }
  }

  Future<void> deleteCourse(String courseId, String userId) async {
    await _coursesCollection.doc(courseId).delete();

    NotificationService notificationService = NotificationService();
    Notification notification = Notification(
      id: '',
      type: 'Course Deleted',
      content: 'A course has been deleted.',
      senderId: userId,
      recipientId: 'all', // Or implement a way to notify relevant users
      timestamp: DateTime.now(),
    );
    await notificationService.createNotification(notification);
  }

  Future<List<Topic>> getTopicsForCourse(String courseId) async {
    try {
      DocumentSnapshot courseDoc = await _coursesCollection.doc(courseId).get();
      if (!courseDoc.exists) {
        return []; // Return empty list if course doesn't exist
      }

      List<dynamic> topicsData = courseDoc['topics'] ?? [];
      List<Topic> topics = [];
      
      for (var topicData in topicsData) {
        String topicId;
        if (topicData is Map<String, dynamic>) {
          topicId = topicData['id'];
        } else {
          topicId = topicData.toString();
        }
        
        DocumentSnapshot topicDoc = await _topicsCollection.doc(topicId).get();
        if (topicDoc.exists) {
          topics.add(Topic.fromJson(topicDoc.data() as Map<String, dynamic>));
        }
      }
      return topics;
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception loading topics for course: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error loading topics for course: $e');
      return [];
    }
  }

  Future<String> createTopic(Topic topic) async {
    DocumentReference docRef = await _topicsCollection.add(topic.toJson());
    String topicId = docRef.id;
    topic.id = topicId;
    await _topicsCollection.doc(topicId).set(topic.toJson());
    return docRef.id;
  }

  // Updated addTopicToCourse to include topic details as a Map
  Future<void> addTopicToCourse(
      String courseId, String topicId, String title, String description) async {
    await _coursesCollection.doc(courseId).update({
      'topics': FieldValue.arrayUnion([
        {
          'id': topicId,
          'title': title,
          'description': description,
        }
      ])
    });
  }

  // Fixed updateTopic method to properly update the topic in Firestore
  Future<void> updateTopic(Topic newTopic, Topic oldTopic) async {
    try {
      // 1. Update the topic document in the topics collection
      await _topicsCollection.doc(newTopic.id).update(newTopic.toJson());
      
      // 2. Update the topic reference in the course document
      // First, get the course document
      DocumentSnapshot courseDoc = await _coursesCollection.doc(newTopic.courseId).get();
      
      if (courseDoc.exists) {
        // Get the topics array from the course
        List<dynamic> topicsData = courseDoc['topics'] ?? [];
        List<dynamic> updatedTopicsData = [];
        bool topicFound = false;
        
        // Update the topic in the array
        for (var topicData in topicsData) {
          if (topicData is Map<String, dynamic> && topicData['id'] == newTopic.id) {
            // Update the topic data
            updatedTopicsData.add({
              'id': newTopic.id,
              'title': newTopic.title,
              'description': newTopic.description,
            });
            topicFound = true;
          } else {
            // Keep the existing topic data
            updatedTopicsData.add(topicData);
          }
        }
        
        // If the topic wasn't found in the array, no need to update the course
        if (topicFound) {
          await _coursesCollection.doc(newTopic.courseId).update({
            'topics': updatedTopicsData
          });
        }
      }
      
      // 3. Create a notification for the update
      if (newTopic.title != oldTopic.title || 
          newTopic.description != oldTopic.description ||
          newTopic.studyVideoUrl != oldTopic.studyVideoUrl ||
          newTopic.attachment != oldTopic.attachment) {
        
        NotificationService notificationService = NotificationService();
        Notification notification = Notification(
          id: '',
          type: 'Topic Updated',
          content: 'Topic "${newTopic.title}" has been updated.',
          senderId: newTopic.userId,
          recipientId: 'all', // Or implement a way to notify relevant users
          timestamp: DateTime.now(),
        );
        await notificationService.createNotification(notification);
      }
      
      print('Topic updated successfully: ${newTopic.id}');
    } on FirebaseException catch (e) {
      print('Firebase Exception updating topic: ${e.code} - ${e.message}');
      throw Exception('Failed to update topic: ${e.message}');
    } catch (e) {
      print('Error updating topic: $e');
      throw Exception('Failed to update topic: $e');
    }
  }

  Future<void> createCourseWithNotification(
      Course course, String creatorId) async {
    String courseId = await createCourse(course);

    NotificationService notificationService = NotificationService();
    Notification notification = Notification(
      id: '',
      type: 'course',
      content: 'New course available: ${course.title}',
      senderId: creatorId,
      recipientId: 'all', // Or implement a way to notify relevant users
      timestamp: DateTime.now(),
    );
    await notificationService.createNotification(notification);
  }

  Future<List<Course>> getCoursesCreatedByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _coursesCollection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Course.fromJson(data);
        } catch (e) {
          print('Error parsing course document ${doc.id}: $e');
          return null;
        }
      }).where((course) => course != null).cast<Course>().toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception getting courses by user: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting courses by user: $e');
      return [];
    }
  }

  /// New method: Fetch topics for all courses by retrieving all topic documents.
  Future<List<Topic>> getAllTopics() async {
    try {
      QuerySnapshot snapshot = await _topicsCollection.get();
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Topic.fromJson(data);
        } catch (e) {
          print('Error parsing topic document ${doc.id}: $e');
          return null;
        }
      }).where((topic) => topic != null).cast<Topic>().toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception loading topics: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error loading topics: $e');
      return [];
    }
  }
}
