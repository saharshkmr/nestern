import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/feedback.dart';
import 'package:nestern/models/internship.dart';
import 'package:nestern/models/notification.dart';
import 'package:nestern/models/report.dart';
import 'package:nestern/services/notification_service.dart';

class InternshipService {
  final CollectionReference _internshipsCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('internships')
      .collection('listings');

  final CollectionReference _internshipsfeedbackCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('internships')
      .collection('internshipsfeedback');

  final CollectionReference _internshipsreportCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('internships')
      .collection('internshipsreport');

  // Add a reference to the applications collection
  final CollectionReference _applicationsCollection = FirebaseFirestore.instance
      .collection('taurusai')
      .doc('applications')
      .collection('listings');

  // Add your imports and class definition here

  // Existing methods...

  // Add this method to get the count of applied internships for a user
  Future<int> getAppliedInternshipsCount(String userId) async {
    // TODO: Replace with actual logic to fetch applied internships count from your backend or database
    // For now, return a dummy value
    return 0;
  }

  // Add this method to fetch the number of interviews for a user
  Future<int> getInterviewsCount(String userId) async {
    // TODO: Replace with actual implementation to fetch interview count from backend or database
    // For now, return a dummy value
    return 0;
  }


  Future<String> createInternshipReport(Report report) async {
    try {
      // Add the feedback to the internship feedback collection
      DocumentReference docRef = await _internshipsreportCollection.add(report.toJson());
      report.id = docRef.id; // Set the feedback ID to the document ID
      await docRef.set(report.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating internship report: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating internship report: $e');
      rethrow;
    }
  }
  

  Future<String> createInternshipFeedback(Feedback feedback) async {
    try {
      // Add the feedback to the internship feedback collection
      DocumentReference docRef = await _internshipsfeedbackCollection.add(feedback.toJson());
      feedback.id = docRef.id; // Set the feedback ID to the document ID
      await docRef.set(feedback.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating internship feedback: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating internship feedback: $e');
      rethrow;
    }
  }

  Future<String> createInternship(Internship internship) async {
    try {
      DocumentReference docRef = await _internshipsCollection.add(internship.toJson());
      internship.id = docRef.id; // Set the internship ID to the document ID
      await docRef.set(internship.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating internship: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating internship: $e');
      rethrow;
    }
  }

  Future<Internship?> getInternship(String internshipId) async {
    try {
      DocumentSnapshot doc = await _internshipsCollection.doc(internshipId).get();
      return doc.exists
          ? Internship.fromJson(doc.data() as Map<String, dynamic>)
          : null;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting internship: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error getting internship: $e');
      return null;
    }
  }

  Future<List<Internship>> getAllInternships() async {
    try {
      QuerySnapshot snapshot = await _internshipsCollection.get();
      return snapshot.docs
          .map((doc) => Internship.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception getting all internships: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting all internships: $e');
      return [];
    }
  }

  // Method to get internships applied by a user
  Future<List<Internship>> getInternshipsAppliedByUser(String userId) async {
    try {
      print('Fetching applications for userId: $userId');
      
      // First fetch all applications for this user
      Query applicationsQuery = _applicationsCollection.where('userId', isEqualTo: userId);
      QuerySnapshot applicationsSnapshot = await applicationsQuery.get();
      print('Found ${applicationsSnapshot.docs.length} applications for user');
      
      if (applicationsSnapshot.docs.isEmpty) {
        return [];
      }
      
      // Extract internship IDs from applications
      List<String> internshipIds = applicationsSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['internshipId'] as String)
          .toList();

      print('Internship IDs from applications: $internshipIds');

      // Now fetch the actual internship details for these IDs
      List<Internship> appliedInternships = [];

      // Since Firestore doesn't support direct 'where in' for large arrays,
      // we'll fetch each internship individually
      for (String internshipId in internshipIds) {
        Internship? internship = await getInternship(internshipId);
        if (internship != null) {
          appliedInternships.add(internship);
        }
      }

      print('Successfully fetched ${appliedInternships.length} internships applied by user');
      return appliedInternships;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting applied internships: ${e.code} - ${e.message}');
      return [];
    } catch (e, stackTrace) {
      print('Error getting applied internships: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> updateInternship(Internship internship, Internship oldInternship) async {
    //Add old internship parameter
    try {
      await _internshipsCollection.doc(internship.id).update(internship.toJson());

      if (internship != oldInternship) {
        NotificationService notificationService = NotificationService();
        Notification notification = Notification(
          id: '',
          type: 'Internship Updated',
          content: 'Internship ${internship.title} has been updated.',
          senderId: internship.userId!,
          recipientId: 'all', // Or implement a way to notify relevant users
          timestamp: DateTime.now(),
        );
        await notificationService.createNotification(notification);
      }
    } on FirebaseException catch (e) {
      print('Firebase Exception updating internship: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error updating internship: $e');
      rethrow;
    }
  }

  Future<List<Internship>> getInternshipsCreatedByUser(String userId) async {
    Query query = _internshipsCollection.where('userId', isEqualTo: userId);
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Internship.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteInternship(String internshipId, String userId) async {
    //Add userId parameter
    try {
      await _internshipsCollection.doc(internshipId).delete();

      NotificationService notificationService = NotificationService();
      Notification notification = Notification(
        id: '',
        type: 'Internship Deleted',
        content: 'An internship has been deleted.',
        senderId: userId,
        recipientId: 'all', // Or implement a way to notify relevant users
        timestamp: DateTime.now(),
      );
      await notificationService.createNotification(notification);
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting internship: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting internship: $e');
      rethrow;
    }
  }

  Future<List<Internship>> searchInternships(String query) async {
    try {
      QuerySnapshot snapshot = await _internshipsCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: '${query}z')
          .get();
      return snapshot.docs
          .map((doc) => Internship.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception searching internships: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error searching internships: $e');
      return [];
    }
  }

  Future<List<Internship>> getRecentInternships(
      {int limit = 10, DocumentSnapshot? startAfter}) async {
    try {
      Query query =
          _internshipsCollection.orderBy('postedDate', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Internship.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception getting recent internships: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting recent internships: $e');
      return [];
    }
  }

  Future<void> createInternshipWithNotification(Internship internship, String creatorId) async {
    String internshipId = await createInternship(internship);

    NotificationService notificationService = NotificationService();
    Notification notification = Notification(
      id: '',
      type: 'internship',
      content: 'New internship posted: ${internship.title}',
      senderId: creatorId,
      recipientId:
          'all', // You might want to implement a way to notify relevant users
      timestamp: DateTime.now(),
    );
    await notificationService.createNotification(notification);
  }
}